using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

// here we save everything that relates to the participant during a test run
// when a DataFarmerObject is saved this data is used to flesh out the context
// of the measurement
public class ParticipantStatus
{
    public static readonly long NO_PARTICIPANT = -1;
    public static readonly int NO_ARRANGEMENT = -1;

    // debug at least sets the condition to an arbitrary value
    private Condition debugCondition = null;
    // private Condition debugCondition = new Condition(5, 5);

    // Participant Subject ID initially garnered from the external host
    // can also be set from the UI when the run starts
    // not having this set to a sensible value is a show stopper
    // we really should not be starting in that case
    private long participant = NO_PARTICIPANT;

    // trial == iteration of learning using a randomized cube
    // run == group of trials for a participant
    private long trial = 0;
    private bool trialStart = false;

    // answers = category chosen by participant at each trial
    private SortedDictionary<long, string> answers;

    // condition == which set of cubes -> categories was chosen
    // this affects overall what the participant sees during the experiment
    // we need to check this to ensure counterbalancing is correct
    private Condition condition = null;

    // which cube got invoked for a given learning trial
    private Transform cube;

    // what answer they chose for that trial
    private string choice;

    // how far they've moved
    private Dictionary<string, KeyValuePair<float, float>> displacements;

    // we assume only one participant per run hence we can instantiate ourselves here
    private static ParticipantStatus ps = null;

    public static ParticipantStatus GetInstance()
    {
        if (ps == null) ps = new ParticipantStatus();
        return ps;
    }

    // instead of doing everything with static methods
    // leave the door open for configuring ourselves similar to how DataFarmer does it
    // if we use the config file here we should make a separate configuration module
    private ParticipantStatus()
    {
        answers = new SortedDictionary<long, string>();
        displacements = new Dictionary<string, KeyValuePair<float, float>>();
        if (debugCondition != null)
        {
            Debug.Log("setting condition from debugCondition " + debugCondition);
            SetCondition(debugCondition.cubeset, debugCondition.catmap).BuildParticipantFromCondition();
        }
    }

    // this is mainly used when we get the answer during a trial to make code simpler
    public DataFarmer GetDataFarmer()
    {
        return DataFarmer.GetInstance();
    }

    // use this method when setting the participant id by hand
    public ParticipantStatus SetParticipant(string part)
    {
        Debug.Log("trying to set participant id to " + part);
        try
        {
            long.TryParse(part, out participant);
            Debug.Log("participant id now " + participant);
        }
        catch (Exception e)
        {
            participant = -1;
            Debug.Log(string.Format("error setting participant {0}: {1}: {2}", part, e, e.Message));
        }
        return this;
    }

    // used in the UI where the participant id can be changed
    public string GetParticipantAsString()
    {
        return GetParticipant().ToString();
    }

    // in the UI we don't use DataFarmer directly 
    // hence we bootstrap a new ID if the participant isn't set
    public long GetParticipant()
    {
        if (participant == NO_PARTICIPANT)
        {
            SetParticipant(GetDataFarmer().NewParticipant());
        }
        return participant;
    }

    public bool ChoiceMade()
    {
        if (GetTrialChoice(this.trial) != null) return true;
        return false;
    }

    public long IncTrial()
    {
        if (Cubes == null || ChoiceMade())
        {
            GetNextStimulus();
            this.trial++;
            bool saveme = true;
            GetDataFarmer().Save(new DFAnswerSelection(DFAnswerSelection.START), saveme);
        }
        return this.trial;
    }

    public bool IsFinished()
    {
        if (DataFarmer.TRIALS > 0 && this.trial >= DataFarmer.TRIALS)
        {
            return true;
        }
        return false;
    }

    public long GetTrial()
    {
        return this.trial;
    }

    public bool IsTrialStart()
    {
        return this.trialStart;
    }

    public void UnsetTrialStart()
    {
        this.trialStart = false;
    }

    // TODO: should this stuff be in its own class??
    // this assumes we've had at least one trial and will only accept the first answer
    public bool SetChoice(string ans)
    {
        if (answers.ContainsKey(trial)) return false;
        answers.Add(trial, ans);
        return true;
    }

    public string GetLastChoice()
    {
        if (trial >= 0) return answers[trial];
        return null;
    }

    public string GetTrialChoice(long t)
    {
        if (answers.ContainsKey(t)) return answers[t];
        return null;
    }

    // TODO: this stuff should probably be in its own class
    // used by the DistanceTravelled.cs script to save the displacements of something
    public void UpdateDisplacement(string tag, float displacement)
    {
        var TimeVsDist = new KeyValuePair<float, float>(Time.time, displacement);
        if (displacements.ContainsKey(tag))
        {
            displacements[tag] = TimeVsDist;
        }
        else
        {
            displacements.Add(tag, TimeVsDist);
        }
    }

    // create a string that we can save of the last saved displacements
    public string DisplacementsToString()
    {
        var sb = new StringBuilder();
        foreach (var kv in displacements)
        {
            // probably want to think of a better way to present this information
            sb.AppendFormat("{0}={1},", kv.Key, kv.Value.Value);
        }
        return sb.ToString();
    }

    // TODO: this stuff that explictly references Cubes 
    // and Cube specific data such as the 2 part condition 
    // should probably exist in its own set of classes

    // set the counterbalancing condition for this participant
    public void SetCatmap(int cubeset, int arrangement)
    {
        this.condition = new Condition(cubeset, arrangement);
    }

    // gets the arrangement for this participant
    public Condition GetCatmap()
    {
        return this.condition;
    }

    public ParticipantStatus SetCondition(int cubeset, int arrangement)
    {
        var cl = GetDataFarmer().CubeLists;

        if (cubeset < 0 || cubeset >= cl.CountCubesets())
            throw new ArgumentException("cubeset is out of bounds");

        if (arrangement < 0 || arrangement >= cl.CountCatmaps(cubeset))
            throw new ArgumentException("arrangement is out of bounds");

        this.condition = new Condition(cubeset, arrangement);
        return this;
    }

    public ParticipantStatus BuildParticipantFromCondition()
    {
        this.participant = GetDataFarmer().FirstParticipant() + this.condition.cubeset * 100 + this.condition.catmap;
        return this;
    }

    // Convenience methods for getting descriptions of cubes:
    // a run is a series of trials that iterate through a list of cubes
    // when we get the end of a list we generate another 
    private List<CubeTuple> Cubes;
    private int Cube = -1;
    public CubeTuple GetNextStimulus()
    {
        if (Cubes == null || Cube >= Cubes.Count - 1)
        {
            ResetCubes();
        } 
        else
        {
            Cube++;
        }
        this.trialStart = true;
        Debug.Log(string.Format("Next stimulus: {0}", Cubes[Cube]));
        return Cubes[Cube];
    }

    public CubeTuple GetCube()
    {
        if (Cube < 0) return null;
        if (Cubes == null) return null;
        return Cubes[Cube];
    }

    // make a random permutation of a given list of cubes
    public void ResetCubes()
    {
        if (this.condition == null)
            throw new ArgumentException("Need to set a condition for this participant!");
        Cubes = GetDataFarmer().CubeLists.Shuffle(this.condition);
        Cube = 0;
    }

    // used in the UI to set the set of cube/category mappings the participant will be learning
    public Condition ConditionFromParticipant()
    {
        if (participant > 0)
        {
            var cl = GetDataFarmer().CubeLists;
            int cubeset = (int)(participant % cl.CountCubesets());
            int arrangement = (int)(participant % cl.CountCatmaps(cubeset));
            this.condition = new Condition(cubeset, arrangement);
            return this.condition;
        }
        else throw new MissingMemberException("Need to set participant");
    }

    public Condition GetCondition()
    {
        return this.condition;
    }

    // See ChoiceBehavior.cs for examples of how this is used
    public string GetCategory()
    {
        if (Cubes == null) return "";
        if (Cube < 0) return "";
        return Cubes[Cube].GetCategory();
    }

    // the condition for this experiment is the set of cubes
    // each participant should be evenly dispersed between the different 
    // possible mappings of the cubes to categories
    public class Condition
    {
        public int cubeset { get; set; } // there are only a small number of ways to generate groups of distinct cubes
        public int catmap { get; set; } // out of these we should select one mapping of cubes to categories

        public Condition(int c, int a)
        {
            cubeset = c;
            catmap = a;
        }

        public override string ToString()
        {
            return string.Format("cubeset={0}/catmap={1}", cubeset, catmap);
        }
    }
}

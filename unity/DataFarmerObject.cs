using UnityEngine;

public class DataFarmerObject : IDataFarmerObject
{
    readonly protected string tag;
    protected float timestamp;
    protected long participant;
    protected long trial;
    protected ParticipantStatus.Condition condition;
    protected string category;
    protected CubeTuple cube;
    protected ParticipantStatus ps;

    public DataFarmerObject(string tag)
    {
        this.tag = tag;
        this.timestamp = Time.time;
        ps = ParticipantStatus.GetInstance();
        this.participant = ps.GetParticipant();
        this.trial = ps.GetTrial();
        this.condition = ps.GetCondition();
        this.category = ps.GetCategory();
        this.cube = ps.GetCube();
    }
    public float GetTimestamp()
    {
        return timestamp;
    }
    public string GetTag()
    {
        return tag;
    }
    public long GetTrial()
    {
        return this.trial;
    }
    public long GetParticipant()
    {
        return this.participant;
    }
    public virtual string Serialize()
    {
        return string.Format("{0},{1},{2},{3},{4},{5},{6}", 
            tag, participant, timestamp, condition, trial, cube, category);
    }
}
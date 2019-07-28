using Newtonsoft.Json;
using System.Collections.Generic;
using UnityEngine;


// stores all possible groups of category/cube maps for the experiment
// one map group is picked for each participant - this is what the participant has to learn
public class CubeArrangements
{
    // Cubesets == our set of counterbalancing conditions
    // first list is organized by possible groups of cubes
    // second list is a set of cat -> cube mapping Catmaps
    // third list is a single Catmap
    // fourth list is the data needed to make one cube
    // ColorShapeRotation describes the properties of one axis (l/r, t/b, f/b)
    // data may be somewhat massaged to make it easier to work with in matlab
    // for example the category is saved redundantly for each dimension
    // this may change ... example:
    // [[[[{"cat":"c0","color":"r","rotation":0,"shape":"O"},{"cat":"c0","color":"b","rotation":120,"shape":"A"},{"cat":"c0","color":"g","rotation":240,"shape":"@"}], ...
    private List<List<List<List<ColorShapeRotation>>>> Cubesets { get; set; }

    // the Catmaps string comes from a JSON data file 
    // see experiments.config.txt Catmaps key or DataFarmer for where this is
    // the file is derived from an external web application
    public CubeArrangements(string Catmaps)
    {
        Cubesets = JsonConvert.DeserializeObject<List<List<List<List<ColorShapeRotation>>>>>(Catmaps);
        foreach (List<List<List<ColorShapeRotation>>> arr in Cubesets)
        {
            Debug.Log(string.Format("we have {0} options", arr.Count));
        }
    }

    public bool IsEmpty()
    {
        return (Cubesets.Count == 0);
    }

    public int CountCatmaps(int cubeset)
    {
        return Cubesets[cubeset].Count;
    }

    public int CountCubesets()
    {
        if (IsEmpty()) return 0;
        return Cubesets.Count;
    }

    public int CountCubes(int cubeset, int catmap)
    {
        if (IsEmpty()) return 0;
        return Cubesets[cubeset][catmap].Count;
    }

    public List<CubeTuple> Shuffle(ParticipantStatus.Condition condition)
    {
        List<List<ColorShapeRotation>> arr = Cubesets[condition.cubeset][condition.catmap];
        CubeTuple[] shuffled = new CubeTuple[arr.Count];
        int i = 0;
        foreach (var c in arr)
        {
            shuffled[i] = new CubeTuple(c);
            i++;
        }
        System.Random random = new System.Random();
        for (i=0; i<arr.Count; i++)
        {
            var replace = random.Next(arr.Count);
            var temp = shuffled[replace];
            shuffled[replace] = shuffled[i];
            shuffled[i] = temp;
        }
        return new List<CubeTuple>(shuffled);
    }
}
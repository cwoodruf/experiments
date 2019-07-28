using Newtonsoft.Json;
using System.Collections.Generic;

public class CubeTuple
{
    public List<ColorShapeRotation> cube { get; set; }

    // the json parser seems to like simpler data structures so we don't try and translate 
    // the cube data into this object directly - see CubeArrangements.cs
    public CubeTuple(List<ColorShapeRotation> cube)
    {
        this.cube = cube;
    }

    // how our categories are translated into game categories
    public static readonly Dictionary<string, string> catmap = new Dictionary<string, string>
    {
        { "c0", "A" },
        { "c1", "B" },
        { "c2", "C" },
        { "c3", "D" },
    };

    // categories are stored per axis to make the data structure less complex for matlab
    public string GetCategory()
    {
        return catmap[cube[0].cat];
    }

    public override string ToString()
    {
        string cubeStr = string.Format("cat: {0} cube:", GetCategory());
        SortedDictionary<int, string> axes = new SortedDictionary<int, string>();
        foreach (ColorShapeRotation csr in cube)
        {
            axes.Add(csr.rotation, string.Format("/{0}{1}",csr.color,csr.shape));
        }
        foreach (string axis in axes.Values)
        {
            cubeStr = string.Concat(cubeStr, axis);
        }
        return cubeStr;
    }
}

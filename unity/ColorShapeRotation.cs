using Newtonsoft.Json;
using System;
using System.Collections.Generic;

// this class describes one axis of a cube
// built from a JSON dictionary 
public class ColorShapeRotation
{
    public string cat { get; set; } // category for cube - saved redundantly mainly for matlab
    public string color { get; set; } // this is effectively redundant as shapes are always the same color
    public string shape { get; set; } // what we actually present on an axis
    public int rotation { get; set; } // which axis this shape should be displayed on

    // materials are stored in the game in an array 
    // so here we simply return the index into the array
    public static readonly Dictionary<string, int> matmap = new Dictionary<string, int> {
            { "D", 1 }, // red diamonds pattern
            { "O", 2 }, // red omega symbol
            { "@", 3 }, // green vortex shape
            { "=", 4 }, // green parallel lines shape
            { "V", 5 }, // blue triangle with line
            { "A", 6 }, // blue triangle with cross
        };

    public int[] GetFaces()
    {
        switch (rotation)
        {
            case 0: return new int[] { 5, 6 }; // up - down
            case 120: return new int[] { 1, 3 }; // left - right 
            case 240: return new int[] { 2, 4 }; // front - back
            default: throw new Exception("Unknown rotation should be 0, 120 or 240!");
        }
    }

    public int GetMaterial()
    {
        return matmap[shape];
    }

    public override string ToString()
    {
        return string.Format("{0} {1}, ",color,shape);
    }
}
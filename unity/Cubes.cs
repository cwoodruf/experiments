using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Cubes {
    public Material[] material;
    /* material is an array containing the base and feature materials
    INITIAL MATERIAL ORDER
    [0] = base layer 
    [1] = Red Diamond
    [2] = Red Omega
    [3] = Green Sprial
    [4] = Green Bamboo
    [5] = Blue Downward Triangle
    [6] = Blue Upward Triangle
    */

    public static readonly long ConditionCount = 36;
    public static int CurrentCondition = -1;

    public void swap(int [] array, int pos1, int pos2)
    {
        int temp = array[pos1];
        array[pos1] = array[pos2];
        array[pos2] = temp;
        return;
    }

    public Material[] createSet(string type, Renderer rend)
    {

        /*
       MATLIST ORDER
       [0] = base
       [1] = right
       [2] = front
       [3] = left
       [4] = back
       [5] = top
       [6] = bottom

        Function intakes the subject number and desired cube.
        It then determines what icons the features will have and where they will be placed.
        Based on this table:

                F1  F2  F3            F1            F2          F3
              _________________________________________________________
           00|  R   G   B      P0|    F/B           L/R         T/B
           06|  G   R   B      P1|    L/R           F/B         T/B
           12|  G   B   R      P2|    L/R           T/B         F/B
           18|  B   G   R      P3|    T/B           L/R         F/B
           24|  B   R   G      P4|    T/B           F/B         L/R
           30|  R   B   G      P5|    F/B           T/B         L/R

        As there are six of each, there are 36 possible combinations. In this script I will order it
        as pairs (Ix, Py). E.g. the first 6 combinations will be I0, P1-6. The next six combinations
        are I1, P1-6 and so on. The combination is selected based on the subject number.
        */
        int [] FeatureSet = { 1, 2, 3 };
        // feature set values indicate feature set, indexes indicate feature number e.g. F1 = FS[0], FS[0] = 1 = red
        Material[] matlist = rend.materials;

        // Cal: removing this assignment as 
        // as I think doing this explicitly when we start the experiment 
        // is likely to be less error prone
        // int select = subject % ConditionCount;


        int[] face = { 1, 2, 3, 4, 5, 6 };
        /*
            [0] = right
            [1] = front
            [2] = left
            [3] = back
            [4] = top
            [5] = bottom
        */

        int c = 0;
        //This loop decides which set will belong to each feature
        for (int i = 1; i <= CurrentCondition; i++)
        {

            //for every 6th increment, shift feature sets
            if (i % 6 == 0)
            {
                //alternate swaps to ensure all permutations
                if (c % 2 == 0)
                {
                    //Swap F1 with F2
                    swap(FeatureSet, 0, 1);
                }
                else
                {
                    //Swap F2 with F3
                    swap(FeatureSet, 1, 2);
                }
                c++;
            }
        }

        //This loop decides where each feature will go on the cube
        for (int i = 1; i <= CurrentCondition; i++)
        {
            //for every increment, swap positions of features in matlist
            //alternate swaps to ensure all permutations
            if (i % 2 == 0)
            {
                //Swap Top/Bottom positions with Left/Right
                swap(face, 4, 2);
                swap(face, 5, 0);
            }
            else
            {
                //Swap Left/Right positions with Front/Back
                swap(face, 2, 1);
                swap(face, 0, 3);
            }
        }

        matlist[0] = material[0];
        switch (type)
        {
            case "A1":
                matlist[face[0]] = material[FeatureSet[2]];
                matlist[face[1]] = material[FeatureSet[0]];
                matlist[face[2]] = material[FeatureSet[2]];
                matlist[face[3]] = material[FeatureSet[0]];
                matlist[face[4]] = material[FeatureSet[5]];
                matlist[face[5]] = material[FeatureSet[5]];
                break;
            case "A2":
                matlist[face[0]] = material[FeatureSet[2]];
                matlist[face[1]] = material[FeatureSet[0]];
                matlist[face[2]] = material[FeatureSet[2]];
                matlist[face[3]] = material[FeatureSet[0]];
                matlist[face[4]] = material[FeatureSet[6]];
                matlist[face[5]] = material[FeatureSet[6]];
                break;
            case "B1":
                matlist[face[0]] = material[FeatureSet[3]];
                matlist[face[1]] = material[FeatureSet[0]];
                matlist[face[2]] = material[FeatureSet[3]];
                matlist[face[3]] = material[FeatureSet[0]];
                matlist[face[4]] = material[FeatureSet[5]];
                matlist[face[5]] = material[FeatureSet[5]];
                break;
            case "B2":
                matlist[face[0]] = material[FeatureSet[3]];
                matlist[face[1]] = material[FeatureSet[0]];
                matlist[face[2]] = material[FeatureSet[3]];
                matlist[face[3]] = material[FeatureSet[0]];
                matlist[face[4]] = material[FeatureSet[6]];
                matlist[face[5]] = material[FeatureSet[6]];
                break;
            case "C1":
                matlist[face[0]] = material[FeatureSet[2]];
                matlist[face[1]] = material[FeatureSet[1]];
                matlist[face[2]] = material[FeatureSet[2]];
                matlist[face[3]] = material[FeatureSet[1]];
                matlist[face[4]] = material[FeatureSet[5]];
                matlist[face[5]] = material[FeatureSet[5]];
                break;
            case "C2":
                matlist[face[0]] = material[FeatureSet[2]];
                matlist[face[1]] = material[FeatureSet[1]];
                matlist[face[2]] = material[FeatureSet[2]];
                matlist[face[3]] = material[FeatureSet[1]];
                matlist[face[4]] = material[FeatureSet[6]];
                matlist[face[5]] = material[FeatureSet[6]];
                break;
            case "D1":
                matlist[face[0]] = material[FeatureSet[3]];
                matlist[face[1]] = material[FeatureSet[1]];
                matlist[face[2]] = material[FeatureSet[3]];
                matlist[face[3]] = material[FeatureSet[1]];
                matlist[face[4]] = material[FeatureSet[5]];
                matlist[face[5]] = material[FeatureSet[5]];
                break;
            case "D2":
                matlist[face[0]] = material[FeatureSet[3]];
                matlist[face[1]] = material[FeatureSet[1]];
                matlist[face[2]] = material[FeatureSet[3]];
                matlist[face[3]] = material[FeatureSet[1]];
                matlist[face[4]] = material[FeatureSet[6]];
                matlist[face[5]] = material[FeatureSet[6]];
                break;
        }
        return matlist;
    }
}

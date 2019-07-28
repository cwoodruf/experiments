using System;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;

public class FindClosestSide : MonoBehaviour {
    GameObject player;
    public readonly int RIGHT = 0, UP = 1, FORWARD = 2, NOSIDE = 3, NULLSIDE = 4;
    public readonly string[] dirStrings = { "right", "up", "forward", "no side", "NULL" };
    public int previousSide;
    public int thresholdAngle = 56;
    public bool detailedLogging = false;
    public Text angleDisplay;
    public int measurements = 0;
    private ParticipantStatus ps = ParticipantStatus.GetInstance();
    private long trial;

    // Use this for initialization
    void Start () {
        player = GameObject.FindGameObjectWithTag("MainCamera"); // this responds to head movements, Player doesn't
        Debug.Log("Player", player);
        previousSide = -1;
        trial = -1;
    }

    // Update is called once per frame
    public void Update()
    {
        GameObject cube = GameObject.FindGameObjectWithTag("Interactable Object");

        if (player != null && cube != null)
        {           
            if (cube != null)
            {
                Transform transform = cube.GetComponent<Transform>();
                int[] angles = {
                    (int) Math.Abs(Math.Round(Vector3.Angle(player.transform.forward, transform.right)) - 90.0),
                    (int) Math.Abs(Math.Round(Vector3.Angle(player.transform.forward, transform.up)) - 90.0),
                    (int) Math.Abs(Math.Round(Vector3.Angle(player.transform.forward, transform.forward)) - 90.0),
                };
                int max = angles.Max();
                int visibleSide = NOSIDE;
                // basic idea: is the cube face angled towards us enough for us to see it?
                // we also want to check if the player's head is rotated up or to the side too far
                if (max > thresholdAngle)
                {
                    visibleSide = angles.ToList().IndexOf(max);
                }

                bool publishUpdate = false;

                if (ps.GetTrial() != trial)
                {
                    trial = ps.GetTrial();
                    publishUpdate = true;
                }
                else
                {
                    if (visibleSide != previousSide)
                    {
                        publishUpdate = true;
                    }
                }

                if (publishUpdate)
                { 
                    // the last Vector3 is a placeholder for the cumulative movement of the head and hand controllers
                    DataFarmer.GetInstance().Save(
                        new DFFixation(
                            "up="+angles[UP], 
                            "forward="+angles[FORWARD], 
                            "right="+angles[RIGHT],
                            dirStrings[visibleSide],
                            ps.DisplacementsToString()
                        )
                    );
                    previousSide = visibleSide;
                }
                
                if (detailedLogging && measurements % 20 == 0) angleDisplay.text = 
                       "participant " + ps.GetParticipantAsString() 
                       + " condition " + ps.GetCondition().ToString() + "\n"
                       + "right " + player.transform.forward[RIGHT]
                       + " up " + player.transform.forward[UP]
                       + "\n" + dirStrings[UP] + " " + angles[UP]
                       + ", " + dirStrings[RIGHT] + " " + angles[RIGHT]
                       + ", " + dirStrings[FORWARD] + " " + angles[FORWARD]
                       + "\n" + dirStrings[visibleSide] + " is facing you"
                       + "\n" + "correct answer is " + ps.GetCategory();
                       ;
                measurements++;
            }
        }
	}
}

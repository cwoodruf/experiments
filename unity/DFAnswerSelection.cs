using UnityEngine;
using System;

public class DFAnswerSelection: DataFarmerObject
{
    private string chosenAnswer;
    private ParticipantStatus ps = ParticipantStatus.GetInstance();
    public static readonly string START = "trial start";

    public DFAnswerSelection() : base("answer")
    {
        this.chosenAnswer = ps.GetLastChoice();
    }

    public DFAnswerSelection(string choice) : base("answer")
    {
        this.chosenAnswer = choice;
    }

    public override string Serialize()
    {
        return string.Format("{0},{1}\n", base.Serialize(), chosenAnswer);
    }
}

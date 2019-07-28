using UnityEngine;

public class DFFixation : DataFarmerObject {
    private string side;
    private string up;
    private string forward;
    private string right;
    private string displacement;

	public DFFixation(string up, string forward, string right, string side, string displacement): 
        base("fixation")
    {
        this.side = side;
        this.up = up;
        this.forward = forward;
        this.right = right;
        this.displacement = displacement;
    }

    public override string Serialize()
    {
        return string.Format("{0},{1},{2},{3},{4},{5}\n",
                base.Serialize(), up, forward, right, side, displacement);
    }
}

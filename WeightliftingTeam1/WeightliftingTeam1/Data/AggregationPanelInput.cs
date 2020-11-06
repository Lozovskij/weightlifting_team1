using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WeightliftingTeam1.Data
{
    public enum MyPanelType
    {
        Attempts,
        Athletes
    }
    public interface IAthletesPanel
    {
        public string WeightCategory { get; set; }

        public int Weight { get; set; }

        public bool IsMale { get; set; }

        public bool IsFemale { get; set; }

        public bool IsDisqualified { get; set; }
    }

    public class AggregationPanelInput : IAthletesPanel
    {
        public string WeightCategory { get; set; }

        public int Weight { get; set; }

        public bool IsMale { get; set; } = true;

        public bool IsFemale { get; set; } = true;

        public bool IsDisqualified { get; set; }
    }
}

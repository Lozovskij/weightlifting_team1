using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WeightliftingTeam1.Data;
using WeightliftingTeam1.ModelsForOutput;

namespace WeightliftingTeam1.Panels
{
    public class AggregationPanels
    {
        public AttemptPanel AttemptPanel;
        public AggregationPanels(DataForDropdowns dataForDropdowns)
        {
            AttemptPanel = new AttemptPanel(dataForDropdowns);
        }

        public string WeightCategory { get; set; }

        public int Weight { get; set; }

        public bool IsMale { get; set; } = true;

        public bool IsFemale { get; set; } = true;

        public bool IsDisqualified { get; set; }
    }
}

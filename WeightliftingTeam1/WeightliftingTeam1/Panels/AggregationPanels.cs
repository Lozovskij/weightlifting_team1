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
        public DataForDropdowns DataForDropdowns { get; }
        public AttemptPanel AttemptPanel { get; set; }
        public AthletePanel AthletePanel { get; set; }
        public RecordPanel RecordPanel { get; set; }
        public AggregationPanels(DataForDropdowns dataForDropdowns)
        {
            DataForDropdowns = dataForDropdowns;
            AttemptPanel = new AttemptPanel();
            AthletePanel = new AthletePanel();
            RecordPanel = new RecordPanel();
        }
    }
}

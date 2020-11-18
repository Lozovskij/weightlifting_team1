using Microsoft.AspNetCore.Components;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WeightliftingTeam1.Data;
using WeightliftingTeam1.ModelsForOutput;
using WeightliftingTeam1.Panels;

namespace WeightliftingTeam1.Components
{
    public partial class AggregationPanel
    {
        [Parameter]
        public EventCallback<AggregationPanelInput> OnSearchClick { get; set; }

        [Parameter]
        public PanelType PanelType { get; set; }

        public AggregationPanelInput PanelInput { get; set; }

        [Parameter]
        public string[] Competitions { get; set; }

        [Parameter]
        public string[] AthleteNames { get; set; }


        public string[] WeightCategories { get; set; } = new string[] { "one", "two", "three" };

        protected override void OnInitialized()
        {
            PanelInput = new AggregationPanelInput(Competitions, AthleteNames);
        }

        private void ClearPanel()
        {
            PanelInput = new AggregationPanelInput(Competitions, AthleteNames);
        }
    }
}

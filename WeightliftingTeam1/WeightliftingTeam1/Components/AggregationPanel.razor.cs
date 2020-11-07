using Microsoft.AspNetCore.Components;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WeightliftingTeam1.Data;

namespace WeightliftingTeam1.Components
{
    public partial class AggregationPanel
    {
        [Parameter]
        public EventCallback<AggregationPanelInput> OnSearchClick { get; set; }

        [Parameter]
        public PanelType PanelType { get; set; }

        public AggregationPanelInput Input { get; set; }

        public string[] WeightCategories { get; set; } = new string[] { "one", "two", "three" };

        protected override void OnInitialized()
        {
            Input = new AggregationPanelInput();
        }

        private void ClearPanel()
        {
            Input = new AggregationPanelInput();
        }
    }
}

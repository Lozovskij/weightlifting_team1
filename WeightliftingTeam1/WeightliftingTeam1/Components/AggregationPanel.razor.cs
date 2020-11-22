using Microsoft.AspNetCore.Components;
using WeightliftingTeam1.Data;
using WeightliftingTeam1.Panels;

namespace WeightliftingTeam1.Components
{
    public partial class AggregationPanel
    {
        [Parameter]
        public EventCallback<AggregationPanels> OnSearchClick { get; set; }

        [Parameter]
        public PanelType PanelType { get; set; }

        [Parameter]
        public AggregationPanels AggregationPanels { get; set; }

        public string[] WeightCategories { get; set; } = new string[] { "one", "two", "three" };

        protected override void OnInitialized() { }

        private void ClearPanel()
        {
            if (AggregationPanels == null)
            {
                return;
            }
            switch (PanelType)
            {
                case PanelType.Attempts:
                    AggregationPanels.AttemptPanel = new AttemptPanel(AggregationPanels.DataForDropdowns);
                    break;
                case PanelType.Athletes:
                    //AggregationPanels.AthletePanel = new AthletePanel(DataForDropdowns);
                    break;
            }
        }
    }
}

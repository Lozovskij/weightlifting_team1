using Microsoft.AspNetCore.Components;
using System.Threading.Tasks;
using WeightliftingTeam1.Data;
using WeightliftingTeam1.Panels;

namespace WeightliftingTeam1.Components
{
    public partial class AggregationPanel
    {
        [Parameter]
        public EventCallback<PanelType> OnSearchClick { get; set; }

        [Parameter]
        public EventCallback<PanelType> OnClearButtonClick { get; set; }

        [Parameter]
        public PanelType PanelType { get; set; }

        [Parameter]
        public AggregationPanels AggregationPanels { get; set; }
    }
}

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

        [Parameter]
        public Task<DataForDropdowns> GetDataForDropdownsTask { get; set; }

        protected override async Task OnInitializedAsync()
        {
            AggregationPanels.DataForDropdowns = await Task.Run(() => InitializeDataForDropdowns());
        }

        private DataForDropdowns InitializeDataForDropdowns() => new DataForDropdowns
        {
            Competitions = searchResultService.GetCompetitions(),
            Countries = searchResultService.GetCountries(),
            AthleteNames = searchResultService.GetAthleteNames()
        };

    }
}

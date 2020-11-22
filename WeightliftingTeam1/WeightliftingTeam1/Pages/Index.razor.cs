using Microsoft.AspNetCore.Components;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WeightliftingTeam1.Components;
using WeightliftingTeam1.Data;
using WeightliftingTeam1.ModelsForOutput;
using WeightliftingTeam1.Panels;

namespace WeightliftingTeam1.Pages
{
    public partial class Index
    {
        public List<IGridModel> DataForGrid { get; set; }

        public PanelType CurrPanelType { get; set; }

        public DataForDropdowns DataForDropdowns { get; set; }

        public AggregationPanels AggregationPanels { get; set; }

        protected override async Task OnInitializedAsync()
        {
            CurrPanelType = PanelType.Attempts;

            //get it from the service, it is for dropdown
            string[] competitions = { "Olimpic games 2019", "Winter olimpics 22", "Universe competition" };
            string[] athleteNames = { "DIMAS Pyrros", "ASANIDZE George", "BAGHERI Kouroush", " WU Jingbiao" };
            DataForDropdowns = new DataForDropdowns(competitions, athleteNames);

            AggregationPanels = new AggregationPanels(DataForDropdowns);//it is Default Panel Input
            await UpdateTable(AggregationPanels);
        }

        public async Task ChangePanelTypeEvent(ChangeEventArgs e)
        {
            CurrPanelType = (PanelType)Enum.Parse(typeof(PanelType), e.Value.ToString(), true);
            await UpdateTable(AggregationPanels);
        }

        public async Task UpdateTable(AggregationPanels aggregationPanels)
        {
            switch (CurrPanelType)
            {
                case PanelType.Attempts:
                    DataForGrid = (await searchResultService.FindData(aggregationPanels.AttemptPanel)).Cast<IGridModel>().ToList();
                    break;
                case PanelType.Athletes:
                    DataForGrid = null;
                    break;
            }
        }
    }
}

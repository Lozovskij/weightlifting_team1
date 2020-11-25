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
        public PanelType CurrPanelType { get; set; }

        public AggregationPanels AggregationPanels { get; set; }

        public DataForGrids DataForGrids { get; set; }

        protected override async Task OnInitializedAsync()
        {
            CurrPanelType = PanelType.Attempts;
            AggregationPanels = await InitializeAggregationPanels();
            DataForGrids = await InitializeDataForGrids();
        }

        private async Task<DataForGrids> InitializeDataForGrids()
        {
            DataForGrids dataForGrids = new DataForGrids();
            dataForGrids.DefaultAthletes = null;
            dataForGrids.DefaultAttempts = await searchResultService.FindData(AggregationPanels.AttemptPanel);
            dataForGrids.Athletes = dataForGrids.DefaultAthletes;
            dataForGrids.Attempts = dataForGrids.DefaultAttempts;
            return dataForGrids;
        }

        private async Task<AggregationPanels> InitializeAggregationPanels()
        {
            //get it from the service, it is for dropdown
            string[] competitions = { "Olimpic games 2019", "Winter olimpics 22", "Universe competition" };
            string[] athleteNames = { "DIMAS Pyrros", "ASANIDZE George", "BAGHERI Kouroush", " WU Jingbiao" };
            string[] countries = { "Abkhazia", "Australia", "Brazil", "Belarus" };
            DataForDropdowns dataForDropdowns = new DataForDropdowns(competitions, athleteNames, countries);
            return new AggregationPanels(dataForDropdowns);
        }

        public void ChangePanelTypeEvent(ChangeEventArgs e)
        {
            CurrPanelType = (PanelType)Enum.Parse(typeof(PanelType), e.Value.ToString(), true);
        }

        private async Task SetDataForGrid(PanelType panelType)
        {
            Console.WriteLine("setting data for grid");
            if (panelType == PanelType.Attempts)
            {
                Console.WriteLine("setting data");
                DataForGrids.Attempts = await searchResultService.FindData(AggregationPanels.AttemptPanel);
            }
            else if (panelType == PanelType.Athletes)
            {
                DataForGrids = null;
            }
            else
            {
                DataForGrids = null;
            }
        }

        public void OnClearButtonClick(PanelType panelType)
        {
            switch (panelType)
            {
                case PanelType.Attempts:
                    DataForGrids.Attempts = DataForGrids.DefaultAttempts;
                    AggregationPanels.AttemptPanel = new AttemptPanel();
                    break;
                case PanelType.Athletes:
                    DataForGrids.Athletes = DataForGrids.DefaultAthletes;
                    AggregationPanels.AthletePanel = new AthletePanel();
                    break;
            }
        }
    }
}

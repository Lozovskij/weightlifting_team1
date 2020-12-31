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
            AggregationPanels = new AggregationPanels(new DataForDropdowns());
            DataForGrids = new DataForGrids
            {
                Attempts = searchResultService.FindData(AggregationPanels.AttemptPanel)
            };
            AggregationPanels.DataForDropdowns = await Task.Run(() => InitializeDataForDropdowns());
            DataForGrids = await Task.Run(() => InitializeDataForGrids());
        }

        private DataForGrids InitializeDataForGrids()
        {
            DataForGrids dataForGrids = new DataForGrids
            {
                DefaultAthletes = searchResultService.FindData(AggregationPanels.AthletePanel),
                DefaultAttempts = searchResultService.FindData(AggregationPanels.AttemptPanel), 
                DefaultRecords = searchResultService.FindData(AggregationPanels.RecordPanel)
            };
            dataForGrids.Athletes = dataForGrids.DefaultAthletes;
            dataForGrids.Attempts = dataForGrids.DefaultAttempts;
            dataForGrids.Records = dataForGrids.DefaultRecords;

            return dataForGrids;
        }

        private DataForDropdowns InitializeDataForDropdowns() => new DataForDropdowns {
                Competitions = searchResultService.GetCompetitions(),
                Countries = searchResultService.GetCountries(),
                AthleteNames = searchResultService.GetAthleteNames()
        };

        //public void ChangePanelTypeEvent(ChangeEventArgs e)
        //{
        //    CurrPanelType = (PanelType)Enum.Parse(typeof(PanelType), e.Value.ToString(), true);
        //}

        public void ChangePanelTypeEvent(PanelType panelType)
        {
            CurrPanelType = panelType;
        }

        private void SetDataForGrid(PanelType panelType)
        {
            if (panelType == PanelType.Attempts)
            {
                DataForGrids.Attempts = searchResultService.FindData(AggregationPanels.AttemptPanel);
            }
            else if (panelType == PanelType.Athletes)
            {
                DataForGrids.Athletes = searchResultService.FindData(AggregationPanels.AthletePanel);
            }
            else if (panelType == PanelType.Records)
            {
                DataForGrids.Records = searchResultService.FindData(AggregationPanels.RecordPanel);
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
                case PanelType.Records:
                    DataForGrids.Records = DataForGrids.DefaultRecords;
                    AggregationPanels.RecordPanel = new RecordPanel();
                    break;
            }
        }
    }
}

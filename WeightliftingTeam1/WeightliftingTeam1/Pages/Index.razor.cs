using Microsoft.AspNetCore.Components;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
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

        public Task<IEnumerable<Attempt>> AttemptsTask { get; set; }
        public Task<IEnumerable<Athlete>> AthletsTask { get; set; }
        public Task<IEnumerable<Record>> RecordsTask { get; set; }

        public GridForUsers<Attempt> AttemptsGrid { get; set; }
        public GridForUsers<Athlete> AthletesGrid { get; set; }
        public GridForUsers<Record> RecordsGrid { get; set; }

        protected override async Task OnInitializedAsync()
        {
            CurrPanelType = PanelType.Attempts;
            AggregationPanels = new AggregationPanels(new DataForDropdowns());

            AttemptsTask = Task.Run(() => (IEnumerable<Attempt>)searchResultService.FindData(AggregationPanels.AttemptPanel).OrderByDescending(item => item.Competition));
            AthletsTask = Task.Run(() => (IEnumerable<Athlete>)searchResultService.FindData(AggregationPanels.AthletePanel).OrderBy(item => item.Name));
            RecordsTask = Task.Run(() => (IEnumerable<Record>)searchResultService.FindData(AggregationPanels.RecordPanel).OrderByDescending(item=>item.Competition));

            AggregationPanels.DataForDropdowns = await Task.Run(() => InitializeDataForDropdowns());
        }

        private DataForDropdowns InitializeDataForDropdowns() => new DataForDropdowns
        {
            Competitions = searchResultService.GetCompetitions().OrderByDescending(item => item),
            Countries = searchResultService.GetCountries().OrderBy(item => item),
            AthleteNames = searchResultService.GetAthleteNames().OrderBy(item => item)
        };

        private void SetDataForGrid(PanelType panelType)
        {
            if (panelType == PanelType.Attempts)
            {
                AttemptsGrid.GridData = searchResultService.FindData(AggregationPanels.AttemptPanel).OrderByDescending(item => item.Competition);
            }
            else if (panelType == PanelType.Athletes)
            {
                AthletesGrid.GridData = searchResultService.FindData(AggregationPanels.AthletePanel).OrderBy(item => item.Name);
            }
            else if (panelType == PanelType.Records)
            {
                RecordsGrid.GridData = searchResultService.FindData(AggregationPanels.RecordPanel).OrderByDescending(item => item.Competition);
            }
        }

        public void OnClearButtonClick(PanelType panelType)
        {

            switch (panelType)
            {
                case PanelType.Attempts:
                    AttemptsGrid.SetDefaultData();
                    AggregationPanels.AttemptPanel = new AttemptPanel();
                    break;
                case PanelType.Athletes:
                    AthletesGrid.SetDefaultData();
                    AggregationPanels.AthletePanel = new AthletePanel();
                    break;
                case PanelType.Records:
                    RecordsGrid.SetDefaultData();
                    AggregationPanels.RecordPanel = new RecordPanel();
                    break;
            }
        }
    }
}

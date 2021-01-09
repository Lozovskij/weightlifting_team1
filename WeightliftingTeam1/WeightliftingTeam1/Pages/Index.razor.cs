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

        public DataForGrids DataForGrids { get; set; }

        public Task<IEnumerable<Attempt>> AttemptsTask { get; set; }
        public Task<IEnumerable<Athlete>> AthletsTask { get; set; }
        public Task<IEnumerable<Record>> RecordsTask { get; set; }

        public GridForUsers<Attempt> AttemptsGrid { get; set; }
        public GridForUsers<Athlete> AthletesGrid { get; set; }
        public GridForUsers<Record> RecordsGrid { get; set; }

        protected override void OnInitialized()
        {
            CurrPanelType = PanelType.Attempts;
            AggregationPanels = new AggregationPanels(new DataForDropdowns());

            AttemptsTask = Task.Run(() => searchResultService.FindData(AggregationPanels.AttemptPanel));
            AthletsTask = Task.Run(() => searchResultService.FindData(AggregationPanels.AthletePanel));
            RecordsTask = Task.Run(() => searchResultService.FindData(AggregationPanels.RecordPanel));
        }


        //public void ChangePanelTypeEvent(ChangeEventArgs e)
        //{
        //    CurrPanelType = (PanelType)Enum.Parse(typeof(PanelType), e.Value.ToString(), true);
        //}

        //public void ChangePanelTypeEvent(PanelType panelType)
        //{
        //    CurrPanelType = panelType;
        //}

        private void SetDataForGrid(PanelType panelType)
        {
            if (panelType == PanelType.Attempts)
            {
                AttemptsGrid.GridData = searchResultService.FindData(AggregationPanels.AttemptPanel);
            }
            else if (panelType == PanelType.Athletes)
            {
                AthletesGrid.GridData = searchResultService.FindData(AggregationPanels.AthletePanel);
            }
            else if (panelType == PanelType.Records)
            {
                RecordsGrid.GridData = searchResultService.FindData(AggregationPanels.RecordPanel);
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

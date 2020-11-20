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

        private string[] Competitions { get; set; }

        private string[] AthleteNames { get; set; }

        public AggregationPanels PanelInput { get; set; }

        protected override async Task OnInitializedAsync()
        {
            CurrPanelType = PanelType.Attempts;

            //get it from the service, it is for dropdown
            Competitions = new string[] { "Olimpic games 2019", "Winter olimpics 22", "Universe competition" };
            AthleteNames = new string[] { "DIMAS Pyrros", "ASANIDZE George", "BAGHERI Kouroush", " WU Jingbiao" };
            PanelInput = new AggregationPanels(Competitions, AthleteNames);//it is Default Panel Input
            await UpdateTable(PanelInput);
        }

        public async Task ChangePanelTypeEvent(ChangeEventArgs e)
        {
            CurrPanelType = (PanelType)Enum.Parse(typeof(PanelType), e.Value.ToString(), true);
            await UpdateTable(PanelInput);
        }

        public async Task UpdateTable(AggregationPanels panelInput)
        {
            switch (CurrPanelType)
            {
                case PanelType.Attempts:
                    DataForGrid = (await searchResultService.SearchForAttempts(panelInput)).Cast<IGridModel>().ToList();
                    break;
                case PanelType.Athletes:
                    DataForGrid = null;
                    break;
            }
        }
    }
}

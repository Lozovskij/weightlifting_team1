using Microsoft.AspNetCore.Components;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WeightliftingTeam1.Data;
using WeightliftingTeam1.ModelsForOutput;

namespace WeightliftingTeam1.Pages
{
    public partial class Index
    {
        public List<IGridModel> DataForGrid { get; set; }

        public PanelType CurrPanelType { get; set; }

        public AggregationPanelInput PanelInput { get; set; }

        protected override async Task OnInitializedAsync()
        {
            CurrPanelType = PanelType.Attempts;
            //it is Default Panel Input
            PanelInput = new AggregationPanelInput();
            await UpdateTable(PanelInput);
        }

        public async Task ChangePanelTypeEvent(ChangeEventArgs e)
        {
            CurrPanelType = (PanelType)Enum.Parse(typeof(PanelType), e.Value.ToString(), true);
            await UpdateTable(PanelInput);
        }

        public async Task UpdateTable(AggregationPanelInput panelInput)
        {
            switch (CurrPanelType)
            {
                //Stratagy???
                case PanelType.Attempts:
                    DataForGrid = (await searchResultService.GetAthleteResults(panelInput)).Cast<IGridModel>().ToList();
                    break;
                case PanelType.Athletes:
                    DataForGrid = null;
                    break;
            }

            //ChangeServiceSearchStrategy();
            //searchResultService.ChangeSearchStrategy(PanelType);
            //Data = await searchResultService.GetSearchResults();
            Console.WriteLine(CurrPanelType);
        }
    }
}

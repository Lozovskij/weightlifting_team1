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

        public MyPanelType PanelType { get; set; }

        public AggregationPanelInput PanelInput { get; set; }

        protected override async Task OnInitializedAsync()
        {
            PanelType = MyPanelType.Attempts;
            //it is Default Panel Input
            PanelInput = new AggregationPanelInput();
            await UpdateTable(PanelInput);
        }

        public async Task ChangePanelTypeEvent(ChangeEventArgs e)
        {
            PanelType = (MyPanelType)Enum.Parse(typeof(MyPanelType), e.Value.ToString(), true);
            await UpdateTable(PanelInput);
        }

        public async Task UpdateTable(AggregationPanelInput panelInput)
        {
            switch (PanelType)
            {
                //Stratagy???
                case MyPanelType.Attempts:
                    DataForGrid = (await searchResultService.GetAthleteResults(panelInput)).Cast<IGridModel>().ToList();
                    break;
                case MyPanelType.Athletes:
                    DataForGrid = null;
                    break;
            }

            //ChangeServiceSearchStrategy();
            //Data = await searchResultService.GetSearchResults();
            Console.WriteLine(PanelType);
        }
    }
}

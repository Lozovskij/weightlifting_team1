﻿using Microsoft.AspNetCore.Components;
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

        public List<Attempt> Attempts { get; set; }
        public List<Athlete> Athletes { get; set; }

        public MyPanelType PanelType { get; set; }

        public AggregationPanelInput DefaultPanelInput { get; set; }

        protected override async Task OnInitializedAsync()
        {
            PanelType = MyPanelType.Attempts;
            DefaultPanelInput = new AggregationPanelInput();
            Attempts = await Task.Run(() => searchResultService.GetAthleteResults(DefaultPanelInput));
        }

        public async Task ChangePanelTypeEvent(ChangeEventArgs e)
        {
            PanelType = (MyPanelType)Enum.Parse(typeof(MyPanelType), e.Value.ToString(), true);
            await UpdateData(DefaultPanelInput);
        }


        public async Task ChangeResultForGrid(AggregationPanelInput panelInput)
        {
            //AthleteResults = athleteResultService.GetSearchResults(panelInput, PanelType)
            await UpdateData(panelInput);
            Console.WriteLine(panelInput.WeightCategory);
            Console.WriteLine(PanelType);
        }

        public async Task UpdateData(AggregationPanelInput panelInput)
        {
            switch (PanelType)
            {
                case MyPanelType.Attempts:
                    Attempts = await Task.Run(() => searchResultService.GetAthleteResults(panelInput));
                    break;
                case MyPanelType.Athletes:
                    Athletes = null;
                    break;
            }
        }
    }
}
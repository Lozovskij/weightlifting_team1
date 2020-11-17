using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WeightliftingTeam1.Components;
using WeightliftingTeam1.ModelsForOutput;
using WeightliftingTeam1.Panels;

namespace WeightliftingTeam1.Data
{
    public class SearchResultService
    {
        public async Task<List<IGridModel>> SearchForAttempts(AggregationPanelInput panelInput)
        {
            //request = CreateRequest(panelInput)
            //data = await GetDataFromDB(request);
            //return data;

            List<IGridModel> results = new List<IGridModel>() {
                new Attempt(){ Date = "07.11.2020", AthleteName = "Ivan Ivanov", Competition = "Olimpic games 2020", Excercise = "Snatch",
                WeightCategory = "70-83 kg", Result = 130 
                }
            };
            return await Task.Run(() => results);
        }
    }

    //here you can do anything you need to get the data
    public static class HelpSearchForAttempts
    {
        public static string CreateRequest()
        {
            throw new NotImplementedException();
        }

        public static Task<IGridModel> GetDataFromDB(string request)
        {
            throw new NotImplementedException();
        }
    }
}

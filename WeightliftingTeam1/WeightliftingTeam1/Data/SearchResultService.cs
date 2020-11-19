using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WeightliftingTeam1.Components;
using WeightliftingTeam1.Models;
using WeightliftingTeam1.ModelsForOutput;
using WeightliftingTeam1.Panels;

namespace WeightliftingTeam1.Data
{
    public class SearchResultService
    {
        public async Task<List<IGridModel>> SearchForAttempts(AggregationPanels panelInput)
        {
            //request = CreateRequest(panelInput)
            //data = await GetDataFromDB(request);
            //return data;

            return await HelpSearchForAttempts.GetDataFromDB(null);
        }
    }

    //here you can do anything you need to get the data
    public static class HelpSearchForAttempts
    {
        public static string CreateRequest()
        {
            throw new NotImplementedException();
        }

        public static Task<List<IGridModel>> GetDataFromDB(string request)
        {
            using WeightliftingContext db = new WeightliftingContext();
            var attempts = db.Attempts.Select(a => new Attempt
            {
                AthleteName = a.Athlete.Name,
                Competition = a.Competition.Name,
                Date = a.Date.ToString(),
                Excercise = a.Exercise.Name,
                Result = a.Result,
                WeightCategory = db.AttemptCategory.Single(ac => ac.AttemptId == a.Id).Category.Name
            }).ToArray();
            return Task.Run(() => new List<IGridModel>(attempts));
        }
    }
}

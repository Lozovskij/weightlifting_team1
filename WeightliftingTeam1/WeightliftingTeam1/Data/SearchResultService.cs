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
        private readonly IDbContextFactory<WeightliftingContext> _contextFactory;
        public SearchResultService(IDbContextFactory<WeightliftingContext> contextFactory)
        {
            _contextFactory = contextFactory;
        }
        public async Task<IEnumerable<Attempt>> FindData(AttemptPanel attemptPanel)
        {
            //request = CreateRequest(panelInput)
            //data = await GetDataFromDB(request);
            //return data;

            var context = _contextFactory.CreateDbContext();
            return await SearchForAttemptsHelper.GetDataFromDB(null, context);
        }
    }

    //here you can do anything you need to get the data
    public static class SearchForAttemptsHelper
    {
        public static string CreateRequest()
        {
            throw new NotImplementedException();
        }

        public static Task<IEnumerable<Attempt>> GetDataFromDB(string request, WeightliftingContext context)
        {
            var attempts = context.Attempts.Select(a => new Attempt
            {
                AthleteName = a.Athlete.Name,
                Competition = a.Competition.Name,
                Date = a.Date.ToString(),
                Excercise = a.Exercise.Name,
                Result = a.Result,
                WeightCategory = context.AttemptCategory.Single(ac => ac.AttemptId == a.Id).Category.Name
            });
            return Task.Run(() => (IEnumerable<Attempt>)attempts);
        }
    }
}

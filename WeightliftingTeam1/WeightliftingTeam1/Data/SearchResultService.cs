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
            var context = _contextFactory.CreateDbContext();
            return await SearchForAttemptsHelper.GetDataFromDB(context, attemptPanel);
        }
    }

    //here you can do anything you need to get the data
    public static class SearchForAttemptsHelper
    {
        private const string Total = "Total";
        private const string Snatch = "Snatch";
        private const string Press = "Press";
        private const string CleanAndJerk = "Clean and jerk";
        public static Task<IEnumerable<Attempt>> GetDataFromDB(WeightliftingContext context, AttemptPanel attemptPanel)
        {
            var resultAttemtps = context.Attempts.Where(attempt => attempt.Date >= attemptPanel.DateLowerLimit && attempt.Date <= attemptPanel.DateUpperLimit &&
                                                       (attempt.Exercise.Name == (attemptPanel.TotalIsIncluded ? Total : null) ||
                                                       attempt.Exercise.Name == (attemptPanel.SnatchIsIncluded ? Snatch : null) ||
                                                       attempt.Exercise.Name == (attemptPanel.CleanAndPressIsIncluded ? Press : null) ||
                                                       attempt.Exercise.Name == (attemptPanel.CleanAndJerkIsIncluded ? CleanAndJerk : null)) &&
                                                       (attemptPanel.Competition == null || attempt.Competition.Name == attemptPanel.Competition) &&
                                                       (attemptPanel.AthleteName == null || attempt.Athlete.Name == attemptPanel.AthleteName) &&
                                                       attempt.AthleteWeight >= attemptPanel.WeightLowerLimit && attempt.AthleteWeight <= attemptPanel.WeightUpperLimit &&
                                                       attempt.Result >= attemptPanel.ResultLowerLimit && attempt.Result <= attemptPanel.ResultUpperLimit &&
                                                       attempt.IsDsq == attemptPanel.IsDisqualified)
                                                    .Select(attempt => new Attempt
                                                     {
                                                         AthleteName = attempt.Athlete.Name,
                                                         Competition = attempt.Competition.Name,
                                                         Date = attempt.Date.ToString(),
                                                         Excercise = attempt.Exercise.Name,
                                                         Result = attempt.Result,
                                                         WeightCategory = context.AttemptCategory.Single(category => category.AttemptId == attempt.Id).Category.Name
                                                     });
            return Task.Run(() => (IEnumerable<Attempt>)resultAttemtps.ToList());
        }
    }
}

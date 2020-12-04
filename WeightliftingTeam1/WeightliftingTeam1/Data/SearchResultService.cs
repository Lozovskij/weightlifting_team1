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
            using var context = _contextFactory.CreateDbContext();
            return await SearchHelper.GetDataFromDB(context, attemptPanel);
        }

        public async Task<IEnumerable<Athlete>> FindData(AthletePanel athletePanel)
        {
            using var context = _contextFactory.CreateDbContext();
            return await SearchHelper.GetDataFromDB(context, athletePanel);
        }

        public async Task<IEnumerable<Record>> FindData(RecordPanel recordPanel)
        {
            using var context = _contextFactory.CreateDbContext();
            return await SearchHelper.GetDataFromDB(context, recordPanel);
        }

        public async Task<IEnumerable<string>> GetCompetitions()
        {
            using var context = _contextFactory.CreateDbContext();
            return await SearchHelper.GetCompetitions(context);
        }

        public async Task<IEnumerable<string>> GetAthleteNames()
        {
            using var context = _contextFactory.CreateDbContext();
            return await SearchHelper.GetAthleteNames(context);
        }

        public async Task<IEnumerable<string>> GetCountries()
        {
            using var context = _contextFactory.CreateDbContext();
            return await SearchHelper.GetCountries(context);
        }
    }

    //here you can do anything you need to get the data
    public static class SearchHelper
    {
        private const string Total = "Total";
        private const string Snatch = "Snatch";
        private const string Press = "Press";
        private const string CleanAndJerk = "Clean and jerk";
        internal static Task<IEnumerable<Attempt>> GetDataFromDB(WeightliftingContext context, AttemptPanel attemptPanel)
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

        internal static Task<IEnumerable<Athlete>> GetDataFromDB(WeightliftingContext context, AthletePanel athletePanel)
        {
            var resultAthletes = context.Athletes.Where(athlete => athletePanel.Name != null ? athlete.Name == athletePanel.Name : true &&
                                                                   athletePanel.Country != null ? athlete.Country.Name == athletePanel.Country : true &&
                                                                   athletePanel.MenIsIncluded && athletePanel.WomenIsIncluded || 
                                                                        (athletePanel.MenIsIncluded ? athlete.Sex == "men" : athletePanel.WomenIsIncluded && athlete.Sex == "women"))
                                                 .Select(athlete => new Athlete
                                                 {
                                                     Country = athlete.Country.Name,
                                                     DOB = athlete.BirthDate.ToString(),
                                                     Name = athlete.Name,
                                                     Sex = athlete.Sex
                                                 });
            return Task.Run(() => (IEnumerable<Athlete>)resultAthletes.ToList());
        }

        internal static Task<IEnumerable<Record>> GetDataFromDB(WeightliftingContext context, RecordPanel recordPanel)
        {
            var resultRecords = context.Records.Where(record => (recordPanel.MenIsIncluded && recordPanel.WomenIsIncluded ||
                                                                    (recordPanel.MenIsIncluded ? record.Attempt.Athlete.Sex == "men" :
                                                                        recordPanel.WomenIsIncluded && record.Attempt.Athlete.Sex == "women")) &&
                                                                 (record.Attempt.Date >= recordPanel.DateLowerLimit && record.Attempt.Date <= recordPanel.DateUpperLimit) &&
                                                                 (recordPanel.TotalIsIncluded ? record.Exercise.Name == Total : false ||
                                                                 recordPanel.SnatchIsIncluded ? record.Exercise.Name == Snatch : false ||
                                                                 recordPanel.CleanAndPressIsIncluded ? record.Exercise.Name == Press : false ||
                                                                 recordPanel.CleanAndJerkIsIncluded ? record.Exercise.Name == CleanAndJerk : false) &&
                                                                 (recordPanel.Competition == null || record.Attempt.Competition.Name == recordPanel.Competition) &&
                                                                 (recordPanel.AthleteName == null || record.Attempt.Athlete.Name == recordPanel.AthleteName) &&
                                                                 (record.Attempt.AthleteWeight >= recordPanel.WeightLowerLimit && record.Attempt.AthleteWeight <= recordPanel.WeightUpperLimit) &&
                                                                 (recordPanel.IsWorldRecordsIncluded && recordPanel.IsOlympicRecordsIncluded ||
                                                                    (recordPanel.IsWorldRecordsIncluded ? record.RecordTypeNavigation.Name == "World" :
                                                                        recordPanel.IsOlympicRecordsIncluded && record.RecordTypeNavigation.Name == "Olympic")) &&
                                                                 record.Active == recordPanel.IsActive)
                                               .Select(record => new Record
                                               {
                                                   AthleteName = record.Attempt.Athlete.Name,
                                                   Competition = record.Attempt.Competition.Name,
                                                   Excercise = record.Exercise.Name,
                                                   RecordType = record.RecordTypeNavigation.Name,
                                                   Result = record.Attempt.Result,
                                                   WeightCategory = record.Category.Name
                                               });
            return Task.Run(() => (IEnumerable<Record>)resultRecords.ToList());
        }

        internal static Task<IEnumerable<string>> GetCompetitions(WeightliftingContext context)
        {
            return Task.Run(() => (IEnumerable<string>)context.Competitions.Select(competition => competition.Name).ToArray());
        }

        internal static Task<IEnumerable<string>> GetAthleteNames(WeightliftingContext context)
        {
            return Task.Run(() => (IEnumerable<string>)context.Athletes.Select(athlete => athlete.Name).ToArray());
        }

        internal static Task<IEnumerable<string>> GetCountries(WeightliftingContext context)
        {
            return Task.Run(() => (IEnumerable<string>)context.Countries.Select(country => country.Name).ToArray());
        }
    }
}

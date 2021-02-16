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
        public IEnumerable<Attempt> FindData(AttemptPanel attemptPanel)
        {
            return SearchHelper.GetDataFromDB(_contextFactory, attemptPanel);
        }

        public IEnumerable<Athlete> FindData(AthletePanel athletePanel)
        {
            return SearchHelper.GetDataFromDB(_contextFactory, athletePanel);
        }

        public IEnumerable<Record> FindData(RecordPanel recordPanel)
        {
            return SearchHelper.GetDataFromDB(_contextFactory, recordPanel);
        }

        public IEnumerable<string> GetCompetitions()
        {
            return SearchHelper.GetCompetitions(_contextFactory);
        }

        public IEnumerable<string> GetAthleteNames()
        {
            return SearchHelper.GetAthleteNames(_contextFactory);
        }

        public IEnumerable<string> GetCountries()
        {
            return SearchHelper.GetCountries(_contextFactory);
        }
    }

    //here you can do anything you need to get the data
    public static class SearchHelper
    {
        private const string Total = "Total";
        private const string Snatch = "Snatch";
        private const string Press = "Press";
        private const string CleanAndJerk = "Clean and jerk";
        private const string Men = "men";
        private const string Women = "women";
        private const string World = "World";
        private const string Olympic = "Olympic";
        internal static IEnumerable<Attempt> GetDataFromDB(IDbContextFactory<WeightliftingContext> contextFactory, AttemptPanel attemptPanel)
        {
            using var context = contextFactory.CreateDbContext();
            var resultAttemtps = context.Attempts.Where(attempt => (attemptPanel.MenIsIncluded && attemptPanel.WomenIsIncluded || 
                                                            (attemptPanel.MenIsIncluded ? attempt.Athlete.Sex == Men : 
                                                                attemptPanel.WomenIsIncluded && attempt.Athlete.Sex == Women)) &&
                                                       attempt.Date >= attemptPanel.DateLowerLimit && attempt.Date <= attemptPanel.DateUpperLimit &&
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
                                                     Sex = attempt.Athlete.Sex,
                                                     Competition = attempt.Competition.Name,
                                                     Excercise = attempt.Exercise.Name,
                                                     Result = attempt.Result,
                                                     WeightCategory = context.AttemptCategory.Single(category => category.AttemptId == attempt.Id).Category.Name
                                                 });
            return resultAttemtps.ToArray();
        }

        internal static IEnumerable<Athlete> GetDataFromDB(IDbContextFactory<WeightliftingContext> contextFactory, AthletePanel athletePanel)
        {
            using var context = contextFactory.CreateDbContext();
            var resultAthletes = context.Athletes.Where(athlete => (athletePanel.Name == null || athlete.Name == athletePanel.Name) &&
                                                                   (athletePanel.Country == null || athlete.Country.Name == athletePanel.Country) &&
                                                                   (athletePanel.MenIsIncluded && athletePanel.WomenIsIncluded || 
                                                                        (athletePanel.MenIsIncluded ? athlete.Sex == Men : athletePanel.WomenIsIncluded && athlete.Sex == Women)))
                                                 .Select(athlete => new Athlete
                                                 {
                                                     Country = athlete.Country.Name,
                                                     DOB = athlete.BirthDate.ToString(),
                                                     Name = athlete.Name,
                                                     Sex = athlete.Sex
                                                 });
            return resultAthletes.ToArray();
        }

        internal static IEnumerable<Record> GetDataFromDB(IDbContextFactory<WeightliftingContext> contextFactory, RecordPanel recordPanel)
        {
            using var context = contextFactory.CreateDbContext();
            var resultRecords = context.Records.Where(record => (recordPanel.MenIsIncluded && recordPanel.WomenIsIncluded ||
                                                                    (recordPanel.MenIsIncluded ? record.Attempt.Athlete.Sex == Men :
                                                                        recordPanel.WomenIsIncluded && record.Attempt.Athlete.Sex == Women)) &&
                                                                 (record.Attempt.Date >= recordPanel.DateLowerLimit && record.Attempt.Date <= recordPanel.DateUpperLimit) &&
                                                                 (record.Exercise.Name == (recordPanel.TotalIsIncluded ? Total : null) ||
                                                                 record.Exercise.Name == (recordPanel.SnatchIsIncluded ? Snatch : null) ||
                                                                 record.Exercise.Name == (recordPanel.CleanAndPressIsIncluded ? Press : null) ||
                                                                 record.Exercise.Name == (recordPanel.CleanAndJerkIsIncluded ? CleanAndJerk : null)) &&
                                                                 (recordPanel.Competition == null || record.Attempt.Competition.Name == recordPanel.Competition) &&
                                                                 (recordPanel.AthleteName == null || record.Attempt.Athlete.Name == recordPanel.AthleteName) &&
                                                                 (record.Attempt.AthleteWeight >= recordPanel.WeightLowerLimit && record.Attempt.AthleteWeight <= recordPanel.WeightUpperLimit) &&
                                                                 (recordPanel.IsWorldRecordsIncluded && recordPanel.IsOlympicRecordsIncluded ||
                                                                    (recordPanel.IsWorldRecordsIncluded ? record.RecordTypeNavigation.Name == World :
                                                                        recordPanel.IsOlympicRecordsIncluded && record.RecordTypeNavigation.Name == Olympic)) &&
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
            return resultRecords.ToArray();
        }

        internal static IEnumerable<string> GetCompetitions(IDbContextFactory<WeightliftingContext> contextFactory)
        {
            using var context = contextFactory.CreateDbContext();
            return context.Competitions.Select(competition => competition.Name).ToArray();
        }

        internal static IEnumerable<string> GetAthleteNames(IDbContextFactory<WeightliftingContext> contextFactory)
        {
            using var context = contextFactory.CreateDbContext();
            return context.Athletes.Select(athlete => athlete.Name).ToArray();
        }

        internal static IEnumerable<string> GetCountries(IDbContextFactory<WeightliftingContext> contextFactory)
        {
            using var context = contextFactory.CreateDbContext();
            return context.Countries.Select(country => country.Name).ToArray();
        }
    }
}

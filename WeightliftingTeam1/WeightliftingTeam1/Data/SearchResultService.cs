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
        private readonly WeightliftingContext _context;
        public SearchResultService(IDbContextFactory<WeightliftingContext> contextFactory)
        {
            _contextFactory = contextFactory;
            _context = _contextFactory.CreateDbContext();
        }
        public IEnumerable<Attempt> FindData(AttemptPanel attemptPanel)
        {
            return SearchHelper.GetDataFromDB(_context, attemptPanel);
        }

        public IEnumerable<Athlete> FindData(AthletePanel athletePanel)
        {
            return SearchHelper.GetDataFromDB(_context, athletePanel);
        }

        public IEnumerable<Record> FindData(RecordPanel recordPanel)
        {
            return SearchHelper.GetDataFromDB(_context, recordPanel);
        }

        public IEnumerable<string> GetCompetitions()
        {
            return SearchHelper.GetCompetitions(_context);
        }

        public IEnumerable<string> GetAthleteNames()
        {
            return SearchHelper.GetAthleteNames(_context);
        }

        public IEnumerable<string> GetCountries()
        {
            return SearchHelper.GetCountries(_context);
        }

        ~SearchResultService()
        {
            _context.Dispose();
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
        internal static IEnumerable<Attempt> GetDataFromDB(WeightliftingContext context, AttemptPanel attemptPanel)
        {
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
                                                     Competition = attempt.Competition.Name,
                                                     Date = attempt.Date.ToString(),
                                                     Excercise = attempt.Exercise.Name,
                                                     Result = attempt.Result,
                                                     WeightCategory = context.AttemptCategory.Single(category => category.AttemptId == attempt.Id).Category.Name
                                                 });
            return resultAttemtps.ToList();
        }

        internal static IEnumerable<Athlete> GetDataFromDB(WeightliftingContext context, AthletePanel athletePanel)
        {
            var resultAthletes = context.Athletes.Where(athlete => athletePanel.Name != null ? athlete.Name == athletePanel.Name : true &&
                                                                   athletePanel.Country != null ? athlete.Country.Name == athletePanel.Country : true &&
                                                                   athletePanel.MenIsIncluded && athletePanel.WomenIsIncluded || 
                                                                        (athletePanel.MenIsIncluded ? athlete.Sex == Men : athletePanel.WomenIsIncluded && athlete.Sex == Women))
                                                 .Select(athlete => new Athlete
                                                 {
                                                     Country = athlete.Country.Name,
                                                     DOB = athlete.BirthDate.ToString(),
                                                     Name = athlete.Name,
                                                     Sex = athlete.Sex
                                                 });
            return resultAthletes.ToList();
        }

        internal static IEnumerable<Record> GetDataFromDB(WeightliftingContext context, RecordPanel recordPanel)
        {
            var resultRecords = context.Records.Where(record => (recordPanel.MenIsIncluded && recordPanel.WomenIsIncluded ||
                                                                    (recordPanel.MenIsIncluded ? record.Attempt.Athlete.Sex == Men :
                                                                        recordPanel.WomenIsIncluded && record.Attempt.Athlete.Sex == Women)) &&
                                                                 (record.Attempt.Date >= recordPanel.DateLowerLimit && record.Attempt.Date <= recordPanel.DateUpperLimit) &&
                                                                 (recordPanel.TotalIsIncluded ? record.Exercise.Name == Total : false ||
                                                                 recordPanel.SnatchIsIncluded ? record.Exercise.Name == Snatch : false ||
                                                                 recordPanel.CleanAndPressIsIncluded ? record.Exercise.Name == Press : false ||
                                                                 recordPanel.CleanAndJerkIsIncluded ? record.Exercise.Name == CleanAndJerk : false) &&
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
            return resultRecords.ToList();
        }

        internal static IEnumerable<string> GetCompetitions(WeightliftingContext context)
        {
            return context.Competitions.Select(competition => competition.Name).ToArray();
        }

        internal static IEnumerable<string> GetAthleteNames(WeightliftingContext context)
        {
            return context.Athletes.Select(athlete => athlete.Name).ToArray();
        }

        internal static IEnumerable<string> GetCountries(WeightliftingContext context)
        {
            return context.Countries.Select(country => country.Name).ToArray();
        }
    }
}

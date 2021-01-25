using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WeightliftingTeam1.Models;

namespace WeightliftingTeam1.Data
{
    public class CrudService
    {
        private readonly IDbContextFactory<WeightliftingContext> _contextFactory;
        public CrudService(IDbContextFactory<WeightliftingContext> contextFactory)
        {
            _contextFactory = contextFactory;
        }

        public void Create<TEntity>(TEntity entity)
        {
            var propertyInfo = FindProperty(typeof(TEntity));
            using var context = _contextFactory.CreateDbContext();
            propertyInfo.PropertyType.GetMethod("Add").Invoke(propertyInfo.GetValue(context), new object[] { entity });
            context.SaveChanges();
        }

        public TEntity Read<TEntity>(int id)
        {
            var propertyInfo = FindProperty(typeof(TEntity));
            using var context = _contextFactory.CreateDbContext();
            return (TEntity)propertyInfo.PropertyType.GetMethod("Find").Invoke(propertyInfo.GetValue(context),  new object[] { new object[] { id } } );
        }

        public void Update<TEntity>(TEntity entity)
        {
            var propertyInfo = FindProperty(typeof(TEntity));
            using var context = _contextFactory.CreateDbContext();
            propertyInfo.PropertyType.GetMethod("Update").Invoke(propertyInfo.GetValue(context), new object[] { entity });
            context.SaveChanges();
        }

        public void Delete<TEntity>(TEntity entity)
        {
            if (entity is Athletes athete)
            {
                DeleteAthlete(athete);
            }
            else if (entity is Periods period)
            {
                DeletePeriod(period);
            }
            else if (entity is Places place)
            {
                DeletePlace(place);
            }
            else if (entity is Countries country)
            {
                DeleteCountry(country);
            }
            else if (entity is RecordTypes recordType)
            {
                DeleteRecordType(recordType);
            }
            else
            {
                var propertyInfo = FindProperty(typeof(TEntity));
                using var context = _contextFactory.CreateDbContext();
                propertyInfo.PropertyType.GetMethod("Remove").Invoke(propertyInfo.GetValue(context), new object[] { entity });
                context.SaveChanges();
            }
        }

        private void DeleteAthlete(Athletes athlete)
        {
            using var context = _contextFactory.CreateDbContext();
            foreach (var attempt in context.Attempts.Where(attempt => attempt.AthleteId == athlete.Id))
            {
                context.Attempts.Remove(attempt);
            }
            context.Athletes.Remove(athlete);
            context.SaveChanges();
        }

        private void DeletePeriod(Periods period)
        {
            using var context = _contextFactory.CreateDbContext();
            foreach (var weightCategory in context.WeightCategories.Where(weightCategory => weightCategory.PeriodId == period.Id))
            {
                context.WeightCategories.Remove(weightCategory);
            }
            context.Periods.Remove(period);
            context.SaveChanges();
        }

        private void DeletePlace(Places place)
        {
            using var context = _contextFactory.CreateDbContext();
            foreach (var competition in context.Competitions.Where(competition => competition.PlaceId == place.Id).ToArray())
            {
                foreach (var attempt in context.Attempts.Where(attempt => attempt.CompetitionId == competition.Id))
                {
                    context.Attempts.Remove(attempt);
                }
                context.Competitions.Remove(competition);
            }
            context.Places.Remove(place);
            context.SaveChanges();
        }

        private void DeleteCountry(Countries country)
        {
            using var context = _contextFactory.CreateDbContext();
            foreach (var athlete in context.Athletes.Where(athlete => athlete.CountryId == country.Id))
            {
                DeleteAthlete(athlete);
            }
            foreach (var place in context.Places.Where(place => place.CountryId == country.Id))
            {
                DeletePlace(place);
            }
            foreach (var attempt in context.Attempts.Where(attempt => attempt.AthleteCountryId == country.Id))
            {
                context.Attempts.Remove(attempt);
            }
            context.Countries.Remove(country);
            context.SaveChanges();
        }

        private void DeleteRecordType(RecordTypes recordType)
        {
            using var context = _contextFactory.CreateDbContext();
            foreach (var record in context.Records.Where(record => record.RecordType == recordType.Id))
            {
                context.Records.Remove(record);
            }
            context.RecordTypes.Remove(recordType);
            context.SaveChanges();
        }

        private System.Reflection.PropertyInfo FindProperty(Type genericArgumentType)
        {
            return typeof(WeightliftingContext).GetProperties().Single(propertyInfo => propertyInfo.PropertyType.IsGenericType && propertyInfo.PropertyType.GenericTypeArguments[0] == genericArgumentType);
        }
    }
}

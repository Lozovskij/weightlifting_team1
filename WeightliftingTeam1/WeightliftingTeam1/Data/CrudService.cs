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
            var propertyInfo = FindProperty(typeof(TEntity));
            using var context = _contextFactory.CreateDbContext();
            propertyInfo.PropertyType.GetMethod("Remove").Invoke(propertyInfo.GetValue(context), new object[] { entity });
            context.SaveChanges();
        }

        public void DeleteAthlete(Athletes athlete)
        {
            using var context = _contextFactory.CreateDbContext();
            foreach (var attempt in context.Attempts.Where(a => a.Athlete == athlete).ToArray())
            {
                foreach (var record in context.Records.Where(r => r.Attempt == attempt))
                {
                    context.Records.Remove(record);
                }
                context.Attempts.Remove(attempt);
            }
            context.Athletes.Remove(athlete);
            context.SaveChanges();
        }

        public void DeletePeriod(Periods period)
        {
            using var context = _contextFactory.CreateDbContext();
            foreach (var weightCategory in context.WeightCategories.Where(wc => wc.Period == period).ToArray())
            {
                foreach (var record in context.Records.Where(r => r.Category == weightCategory))
                {
                    context.Records.Remove(record);
                }
                context.WeightCategories.Remove(weightCategory);
            }
            context.Periods.Remove(period);
            context.SaveChanges();
        }

        public void DeletePlace(Places place)
        {
            using var context = _contextFactory.CreateDbContext();
            foreach (var competition in context.Competitions.Where(c => c.Place == place).ToArray())
            {
                foreach (var attempt in context.Attempts.Where(a => a.Competition == competition).ToArray())
                {
                    foreach (var record in context.Records.Where(r => r.Attempt == attempt))
                    {
                        context.Records.Remove(record);
                    }
                    context.Attempts.Remove(attempt);
                }
                context.Competitions.Remove(competition);
            }
            context.Places.Remove(place);
            context.SaveChanges();
        }

        private System.Reflection.PropertyInfo FindProperty(Type genericArgumentType)
        {
            return typeof(WeightliftingContext).GetProperties().Single(propertyInfo => propertyInfo.PropertyType.IsGenericType && propertyInfo.PropertyType.GenericTypeArguments[0] == genericArgumentType);
        }
    }
}

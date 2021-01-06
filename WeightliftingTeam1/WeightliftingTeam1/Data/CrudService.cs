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

        private System.Reflection.PropertyInfo FindProperty(Type genericArgumentType)
        {
            return typeof(WeightliftingContext).GetProperties().Single(propertyInfo => propertyInfo.PropertyType.IsGenericType && propertyInfo.PropertyType.GenericTypeArguments[0] == genericArgumentType);
        }
    }
}

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
        private readonly WeightliftingContext _context;
        public CrudService(IDbContextFactory<WeightliftingContext> contextFactory)
        {
            _contextFactory = contextFactory;
            _context = _contextFactory.CreateDbContext();
        }

        public void Create<TEntity>(TEntity entity)
        {
            var propertyInfo = FindProperty(typeof(TEntity));
            propertyInfo.PropertyType.GetMethod("Add").Invoke(propertyInfo.GetValue(_context), new object[] { entity });
            _context.SaveChanges();
        }

        public TEntity Read<TEntity>(int id)
        {
            var propertyInfo = FindProperty(typeof(TEntity));
            return (TEntity)propertyInfo.PropertyType.GetMethod("Find").Invoke(propertyInfo.GetValue(_context), new object[] { id });
        }

        public void Update<TEntity>(TEntity entity)
        {
            var propertyInfo = FindProperty(typeof(TEntity));
            var entityToUpdate = (TEntity)propertyInfo.PropertyType.GetMethod("Find").Invoke(propertyInfo.GetValue(_context), new object[] { typeof(TEntity).GetProperty("Id").GetValue(entity) });
            propertyInfo.PropertyType.GetMethod("Update").Invoke(propertyInfo.GetValue(_context), new object[] { entityToUpdate });
            _context.SaveChanges();
        }

        public void Delete<TEntity>(TEntity entity)
        {
            var propertyInfo = FindProperty(typeof(TEntity));
            propertyInfo.PropertyType.GetMethod("Remove").Invoke(propertyInfo.GetValue(_context), new object[] { entity });
            _context.SaveChanges();
        }

        private System.Reflection.PropertyInfo FindProperty(Type genericPropertyType)
        {
            return typeof(WeightliftingContext).GetProperties().Single(propertyInfo => propertyInfo.PropertyType.IsGenericType && propertyInfo.PropertyType.GetGenericTypeDefinition() == genericPropertyType);
        }
    }
}

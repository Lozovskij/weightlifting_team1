using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WeightliftingTeam1.Data
{
    public class DataRetrievalService
    {
        private readonly IDbContextFactory<WeightliftingContext> _contextFactory;
        public DataRetrievalService(IDbContextFactory<WeightliftingContext> contextFactory)
        {
            _contextFactory = contextFactory;
        }

        public IEnumerable<TEntity> GetData<TEntity>()
        {
            using var context = _contextFactory.CreateDbContext();
            return ((IEnumerable<TEntity>)FindProperty(typeof(TEntity)).GetValue(context)).ToArray();
        }

        private System.Reflection.PropertyInfo FindProperty(Type genericArgumentType)
        {
            return typeof(WeightliftingContext).GetProperties().Single(propertyInfo => propertyInfo.PropertyType.IsGenericType && propertyInfo.PropertyType.GenericTypeArguments[0] == genericArgumentType);
        }
    }
}

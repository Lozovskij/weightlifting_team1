using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WeightliftingTeam1.Context
{
    public class ApplicationDbContext : DbContext
    {
        //public DbSet<>
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseNpgsql("Host=localhost;Port=5432;Database=weightlifting;Username=postgres;Password=password");
        }
    }
}

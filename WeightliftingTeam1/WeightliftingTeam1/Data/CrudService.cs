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

        public void CreateAthlete(Athletes athlete)
        {
            _context.Athletes.Add(athlete);
            _context.SaveChanges();
        }

        public Athletes ReadAthlete(int athleteId)
        {
            return _context.Athletes.Find(athleteId);
        }

        public void UpdateAthlete(Athletes athlete)
        {
            var athleteToUpdate = _context.Athletes.Find(athlete.Id);
            _context.Athletes.Update(athleteToUpdate);
            _context.SaveChanges();
        }

        public void DeleteAthlete(Athletes athlete)
        {
            _context.Athletes.Remove(athlete);
            _context.SaveChanges();
        }

        public void CreateAttempt(Attempts attempt)
        {
            _context.Attempts.Add(attempt);
            _context.SaveChanges();
        }

        public Attempts ReadAttempt(int attemptId)
        {
            return _context.Attempts.Find(attemptId);
        }

        public void UpdateAttempt(Attempts attempt)
        {
            var attemptToUpdate = _context.Attempts.Find(attempt.Id);
            _context.Attempts.Update(attemptToUpdate);
            _context.SaveChanges();
        }

        public void DeleteAttempt(Attempts attempt)
        {
            _context.Attempts.Remove(attempt);
            _context.SaveChanges();
        }
    }
}

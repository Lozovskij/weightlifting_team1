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

        public void CreateCompetition(Competitions competition)
        {
            _context.Competitions.Add(competition);
            _context.SaveChanges();
        }

        public Competitions ReadCompetition(int competitionId)
        {
            return _context.Competitions.Find(competitionId);
        }

        public void UpdateCompetition(Competitions competition)
        {
            var competitionToUpdate = _context.Competitions.Find(competition.Id);
            _context.Competitions.Update(competitionToUpdate);
            _context.SaveChanges();
        }

        public void DeleteCompetition(Competitions competition)
        {
            _context.Competitions.Remove(competition);
            _context.SaveChanges();
        }

        public void CreateExercise(Exercises exercise)
        {
            _context.Exercises.Add(exercise);
            _context.SaveChanges();
        }

        public Exercises ReadExercise(int exerciseId)
        {
            return _context.Exercises.Find(exerciseId);
        }

        public void UpdateExercise(Exercises exercise)
        {
            var exerciseToUpdate = _context.Exercises.Find(exercise.Id);
            _context.Exercises.Update(exerciseToUpdate);
            _context.SaveChanges();
        }

        public void DeleteExercise(Exercises exercise)
        {
            _context.Exercises.Remove(exercise);
            _context.SaveChanges();
        }
    }
}

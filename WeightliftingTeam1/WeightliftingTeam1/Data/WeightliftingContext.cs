using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using WeightliftingTeam1.Models;

namespace WeightliftingTeam1.Data
{
    public partial class WeightliftingContext : DbContext
    {
        public WeightliftingContext(DbContextOptions<WeightliftingContext> options)
            : base(options)
        {
        }

        public virtual DbSet<AthleteComments> AthleteComments { get; set; }
        public virtual DbSet<Athletes> Athletes { get; set; }
        public virtual DbSet<AttemptCategory> AttemptCategory { get; set; }
        public virtual DbSet<Attempts> Attempts { get; set; }
        public virtual DbSet<CompetitionTypes> CompetitionTypes { get; set; }
        public virtual DbSet<Competitions> Competitions { get; set; }
        public virtual DbSet<Countries> Countries { get; set; }
        public virtual DbSet<Disqualifications> Disqualifications { get; set; }
        public virtual DbSet<Exercises> Exercises { get; set; }
        public virtual DbSet<Periods> Periods { get; set; }
        public virtual DbSet<Places> Places { get; set; }
        public virtual DbSet<RecordTypes> RecordTypes { get; set; }
        public virtual DbSet<Records> Records { get; set; }
        public virtual DbSet<WeightCategories> WeightCategories { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.HasPostgresExtension("uuid-ossp");

            modelBuilder.Entity<AthleteComments>(entity =>
            {
                entity.ToTable("athlete_comments");

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.Athleteid).HasColumnName("athleteid");

                entity.Property(e => e.Ban).HasColumnName("ban");

                entity.Property(e => e.Content)
                    .IsRequired()
                    .HasColumnName("content")
                    .HasColumnType("character varying");

                entity.Property(e => e.Date)
                    .HasColumnName("date")
                    .HasColumnType("timestamp with time zone");

                entity.Property(e => e.Updated).HasColumnName("updated");

                entity.Property(e => e.Userid).HasColumnName("userid");

                entity.HasOne(d => d.Athlete)
                    .WithMany(p => p.AthleteComments)
                    .HasForeignKey(d => d.Athleteid)
                    .HasConstraintName("athlete_comments_athleteid_fkey");
            });

            modelBuilder.Entity<Athletes>(entity =>
            {
                entity.ToTable("athletes");

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.About).HasColumnName("about");

                entity.Property(e => e.BirthDate)
                    .HasColumnName("birth_date")
                    .HasColumnType("date");

                entity.Property(e => e.CountryId).HasColumnName("country_id");

                entity.Property(e => e.ImageUrl).HasColumnName("image_url");

                entity.Property(e => e.Name)
                    .HasColumnName("name")
                    .HasColumnType("character varying");

                entity.Property(e => e.NameEn)
                    .HasColumnName("name_en")
                    .HasColumnType("character varying");

                entity.Property(e => e.Sex)
                    .IsRequired()
                    .HasColumnName("sex")
                    .HasColumnType("character varying");

                entity.HasOne(d => d.Country)
                    .WithMany(p => p.Athletes)
                    .HasForeignKey(d => d.CountryId)
                    .HasConstraintName("athletes_countries_id_fk");
            });

            modelBuilder.Entity<AttemptCategory>(entity =>
            {
                entity.HasNoKey();

                entity.ToTable("attempt_category");

                entity.Property(e => e.AttemptId).HasColumnName("attempt_id");

                entity.Property(e => e.CategoryId).HasColumnName("category_id");

                entity.HasOne(d => d.Attempt)
                    .WithMany()
                    .HasForeignKey(d => d.AttemptId)
                    .HasConstraintName("attempt_category_attempts_id_fk");

                entity.HasOne(d => d.Category)
                    .WithMany()
                    .HasForeignKey(d => d.CategoryId)
                    .HasConstraintName("attempt_category_weight_categories_id_fk");
            });

            modelBuilder.Entity<Attempts>(entity =>
            {
                entity.ToTable("attempts");

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.Added).HasColumnName("added");

                entity.Property(e => e.AddedBy).HasColumnName("added_by");

                entity.Property(e => e.AthleteCountryId).HasColumnName("athlete_country_id");

                entity.Property(e => e.AthleteId).HasColumnName("athlete_id");

                entity.Property(e => e.AthleteWeight).HasColumnName("athlete_weight");

                entity.Property(e => e.CompetitionId).HasColumnName("competition_id");

                entity.Property(e => e.Date)
                    .HasColumnName("date")
                    .HasColumnType("date");

                entity.Property(e => e.ExerciseId).HasColumnName("exercise_id");

                entity.Property(e => e.Failed).HasColumnName("failed");

                entity.Property(e => e.HasVideo).HasColumnName("has_video");

                entity.Property(e => e.IsDsq).HasColumnName("is_dsq");

                entity.Property(e => e.IsWinResult).HasColumnName("is_win_result");

                entity.Property(e => e.Result).HasColumnName("result");

                entity.Property(e => e.SourceInfo).HasColumnName("source_info");

                entity.Property(e => e.Updated).HasColumnName("updated");

                entity.Property(e => e.UpdatedBy).HasColumnName("updated_by");

                entity.HasOne(d => d.AthleteCountry)
                    .WithMany(p => p.Attempts)
                    .HasForeignKey(d => d.AthleteCountryId)
                    .OnDelete(DeleteBehavior.SetNull)
                    .HasConstraintName("attempts_countries_id_fk");

                entity.HasOne(d => d.Athlete)
                    .WithMany(p => p.Attempts)
                    .HasForeignKey(d => d.AthleteId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("attempts_athletes_id_fk");

                entity.HasOne(d => d.Competition)
                    .WithMany(p => p.Attempts)
                    .HasForeignKey(d => d.CompetitionId)
                    .OnDelete(DeleteBehavior.SetNull)
                    .HasConstraintName("attempts_competitions_id_fk");

                entity.HasOne(d => d.Exercise)
                    .WithMany(p => p.Attempts)
                    .HasForeignKey(d => d.ExerciseId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("attempts_exercises_id_fk");
            });

            modelBuilder.Entity<CompetitionTypes>(entity =>
            {
                entity.ToTable("competition_types");

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.Name)
                    .HasColumnName("name")
                    .HasColumnType("character varying");
            });

            modelBuilder.Entity<Competitions>(entity =>
            {
                entity.ToTable("competitions");

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.DateEnd)
                    .HasColumnName("date_end")
                    .HasColumnType("date");

                entity.Property(e => e.DateStart)
                    .HasColumnName("date_start")
                    .HasColumnType("date");

                entity.Property(e => e.IsEnd)
                    .HasColumnName("is_end")
                    .HasDefaultValueSql("false");

                entity.Property(e => e.Name).HasColumnName("name");

                entity.Property(e => e.PlaceId).HasColumnName("place_id");

                entity.Property(e => e.SourceInfo).HasColumnName("source_info");

                entity.Property(e => e.Type).HasColumnName("type");

                entity.HasOne(d => d.Place)
                    .WithMany(p => p.Competitions)
                    .HasForeignKey(d => d.PlaceId)
                    .HasConstraintName("competitions_places_id_fk");

                entity.HasOne(d => d.TypeNavigation)
                    .WithMany(p => p.Competitions)
                    .HasForeignKey(d => d.Type)
                    .HasConstraintName("competitions_competition_types_id_fk");
            });

            modelBuilder.Entity<Countries>(entity =>
            {
                entity.ToTable("countries");

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.Exists).HasColumnName("exists");

                entity.Property(e => e.Name)
                    .HasColumnName("name")
                    .HasColumnType("character varying");

                entity.Property(e => e.RuName)
                    .HasColumnName("ru_name")
                    .HasColumnType("character varying");

                entity.Property(e => e.ShortName)
                    .HasColumnName("short_name")
                    .HasColumnType("character varying");

                entity.Property(e => e.ShortName2)
                    .HasColumnName("short_name_2")
                    .HasColumnType("character varying");
            });

            modelBuilder.Entity<Disqualifications>(entity =>
            {
                entity.ToTable("disqualifications");

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.AttemptId).HasColumnName("attempt_id");

                entity.Property(e => e.Reason)
                    .HasColumnName("reason")
                    .HasColumnType("character varying");

                entity.HasOne(d => d.Attempt)
                    .WithMany(p => p.Disqualifications)
                    .HasForeignKey(d => d.AttemptId)
                    .HasConstraintName("disqualifications_attempt_id_fkey");
            });

            modelBuilder.Entity<Exercises>(entity =>
            {
                entity.ToTable("exercises");

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.Name).HasColumnName("name");
            });

            modelBuilder.Entity<Periods>(entity =>
            {
                entity.ToTable("periods");

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.Name)
                    .HasColumnName("name")
                    .HasColumnType("character varying");
            });

            modelBuilder.Entity<Places>(entity =>
            {
                entity.ToTable("places");

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.CountryId).HasColumnName("country_id");

                entity.Property(e => e.Name)
                    .HasColumnName("name")
                    .HasColumnType("character varying");

                entity.HasOne(d => d.Country)
                    .WithMany(p => p.Places)
                    .HasForeignKey(d => d.CountryId)
                    .HasConstraintName("places_countries_id_fk");
            });

            modelBuilder.Entity<RecordTypes>(entity =>
            {
                entity.ToTable("record_types");

                entity.HasIndex(e => e.Id)
                    .HasDatabaseName("record_types_id_uindex")
                    .IsUnique();

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasColumnName("name")
                    .HasColumnType("character varying");
            });

            modelBuilder.Entity<Records>(entity =>
            {
                entity.ToTable("records");

                entity.HasIndex(e => e.Id)
                    .HasDatabaseName("records_id_uindex")
                    .IsUnique();

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.Active)
                    .HasColumnName("active")
                    .HasDefaultValueSql("false");

                entity.Property(e => e.Added).HasColumnName("added");

                entity.Property(e => e.AttemptId).HasColumnName("attempt_id");

                entity.Property(e => e.CategoryId).HasColumnName("category_id");

                entity.Property(e => e.ExerciseId).HasColumnName("exercise_id");

                entity.Property(e => e.RecordType).HasColumnName("record_type");

                entity.HasOne(d => d.Attempt)
                    .WithMany(p => p.Records)
                    .HasForeignKey(d => d.AttemptId)
                    .HasConstraintName("records_attempts_id_fk");

                entity.HasOne(d => d.Category)
                    .WithMany(p => p.Records)
                    .HasForeignKey(d => d.CategoryId)
                    .HasConstraintName("records_weight_categories_id_fk");

                entity.HasOne(d => d.Exercise)
                    .WithMany(p => p.Records)
                    .HasForeignKey(d => d.ExerciseId)
                    .HasConstraintName("records_exercises_id_fk");

                entity.HasOne(d => d.RecordTypeNavigation)
                    .WithMany(p => p.Records)
                    .HasForeignKey(d => d.RecordType)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("records_record_types_id_fk");
            });

            modelBuilder.Entity<WeightCategories>(entity =>
            {
                entity.ToTable("weight_categories");

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.Active).HasColumnName("active");

                entity.Property(e => e.FromW).HasColumnName("from_w");

                entity.Property(e => e.Name)
                    .HasColumnName("name")
                    .HasColumnType("character varying");

                entity.Property(e => e.PeriodId).HasColumnName("period_id");

                entity.Property(e => e.ToW).HasColumnName("to_w");

                entity.Property(e => e.Type)
                    .IsRequired()
                    .HasColumnName("type")
                    .HasColumnType("character varying");

                entity.HasOne(d => d.Period)
                    .WithMany(p => p.WeightCategories)
                    .HasForeignKey(d => d.PeriodId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("weight_categories_periods_id_fk");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}

using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace backend.Models
{
    public partial class AirDBContext : DbContext
    {
        public AirDBContext()
        {
        }

        public AirDBContext(DbContextOptions<AirDBContext> options)
            : base(options)
        {
        }

        public virtual DbSet<Card> Cards { get; set; } = null!;
        public virtual DbSet<Charger> Chargers { get; set; } = null!;
        public virtual DbSet<Event> Events { get; set; } = null!;
        public virtual DbSet<User> Users { get; set; } = null!;

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                optionsBuilder.UseNpgsql("Host=localhost;Database=AirDB;Username=postgres;Password=123");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Card>(entity =>
            {
                entity.ToTable("card");

                entity.Property(e => e.CardId)
                    .ValueGeneratedNever()
                    .HasColumnName("card_id");

                entity.Property(e => e.Active).HasColumnName("active");

                entity.Property(e => e.UserId).HasColumnName("user_id");

                entity.Property(e => e.Value).HasColumnName("value");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.Cards)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("user_user_id_fk");
            });

            modelBuilder.Entity<Charger>(entity =>
            {
                entity.ToTable("charger");

                entity.Property(e => e.ChargerId)
                    .ValueGeneratedNever()
                    .HasColumnName("charger_id");

                entity.Property(e => e.Created)
                    .HasColumnType("timestamp without time zone")
                    .HasColumnName("created");

                entity.Property(e => e.Creator).HasColumnName("creator");

                entity.Property(e => e.Lastsync)
                    .HasColumnType("timestamp without time zone")
                    .HasColumnName("lastsync");

                entity.Property(e => e.Latitude).HasColumnName("latitude");

                entity.Property(e => e.Longitude).HasColumnName("longitude");

                entity.HasOne(d => d.CreatorNavigation)
                    .WithMany(p => p.Chargers)
                    .HasForeignKey(d => d.Creator)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("user_user_id_fk");
            });

            modelBuilder.Entity<Event>(entity =>
            {
                entity.ToTable("event");

                entity.Property(e => e.EventId).HasColumnName("event_id");

                entity.Property(e => e.ChargerId).HasColumnName("charger_id");

                entity.Property(e => e.Endtime)
                    .HasColumnType("timestamp without time zone")
                    .HasColumnName("endtime");

                entity.Property(e => e.Starttime)
                    .HasColumnType("timestamp without time zone")
                    .HasColumnName("starttime");

                entity.Property(e => e.UserId).HasColumnName("user_id");

                entity.Property(e => e.Volume)
                    .HasPrecision(10, 2)
                    .HasColumnName("volume");

                entity.HasOne(d => d.Charger)
                    .WithMany(p => p.Events)
                    .HasForeignKey(d => d.ChargerId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("charger_charger_id_fk");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.Events)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("user_user_id_fk");
            });

            modelBuilder.Entity<User>(entity =>
            {
                entity.ToTable("user");

                entity.Property(e => e.UserId)
                    .ValueGeneratedNever()
                    .HasColumnName("user_id");

                entity.Property(e => e.Active).HasColumnName("active");

                entity.Property(e => e.Created).HasColumnName("created");

                entity.Property(e => e.Email)
                    .HasMaxLength(50)
                    .HasColumnName("email");

                entity.Property(e => e.Username)
                    .HasMaxLength(20)
                    .HasColumnName("username");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}

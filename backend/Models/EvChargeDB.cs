using System;
using System.Collections.Generic;
using backend.Models.entity;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace backend.Models
{
    public partial class EvChargeDB : DbContext
    {
        public EvChargeDB()
        {
        }

        public EvChargeDB(DbContextOptions<EvChargeDB> options)
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
                //optionsBuilder.UseNpgsql("Host=192.168.1.124;Database=AirDB;Username=postgres;Password=123");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.HasDefaultSchema("evchargeschema");
            modelBuilder.Entity<Card>(entity =>
            {
                entity.ToTable("card");

                entity.Property(e => e.CardId).HasColumnName("card_id");

                entity.Property(e => e.Active).HasColumnName("active");

                entity.Property(e => e.UserId).HasColumnName("user_id");

                entity.Property(e => e.Value)
                    .HasMaxLength(100)
                    .HasColumnName("value");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.Cards)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("user_user_id_fk");
            });

            modelBuilder.Entity<Charger>(entity =>
            {
                entity.ToTable("charger");

                entity.Property(e => e.ChargerId).HasColumnName("charger_id");

                entity.Property(e => e.Created)
                    .HasColumnType("timestamp without time zone")
                    .HasColumnName("created");

                entity.Property(e => e.Creator).HasColumnName("creator");

                entity.Property(e => e.Lastsync)
                    .HasColumnType("timestamp without time zone")
                    .HasColumnName("lastsync");

                entity.Property(e => e.Latitude)
                    .HasPrecision(9, 6)
                    .HasColumnName("latitude");

                entity.Property(e => e.Longitude)
                    .HasPrecision(9, 6)
                    .HasColumnName("longitude");

                entity.Property(e => e.Name)
                    .HasMaxLength(50)
                    .HasColumnName("name");

                entity.Property(e => e.Active).HasColumnName("active");

                entity.Property(e => e.Occupied).HasColumnName("occupied");

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

                entity.Property(e => e.ChargeTime)
                    .HasColumnType("interval")
                    .HasColumnName("chargetime");

                entity.Property(e => e.UserId).HasColumnName("user_id");

                entity.Property(e => e.Volume)
                    .HasPrecision(10, 2)
                    .HasColumnName("volume");

                entity.Property(e => e.Price)
                    .HasPrecision(10, 2)
                    .HasColumnName("price");

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
                entity.ToTable("users");

                entity.HasIndex(e => e.Email, "unique_email")
                    .IsUnique();

                entity.Property(e => e.UserId).HasColumnName("user_id");

                entity.Property(e => e.Active).HasColumnName("active");

                entity.Property(e => e.Created)
                    .HasColumnType("timestamp without time zone")
                    .HasColumnName("created");

                entity.Property(e => e.Email)
                    .HasMaxLength(50)
                    .HasColumnName("email");

                entity.Property(e => e.Password)
                    .HasMaxLength(60)
                    .HasColumnName("password");

                entity.Property(e => e.Role)
                    .HasMaxLength(30)
                    .HasColumnName("role");

                entity.Property(e => e.Wallet).HasColumnName("wallet");

                entity.Property(e => e.Username)
                    .HasMaxLength(50)
                    .HasColumnName("username");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}

using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;


namespace backend.Data.Migrations
{
    public partial class createDatabase : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "card");

            migrationBuilder.DropTable(
                name: "event");

            migrationBuilder.DropTable(
                name: "charger");

            migrationBuilder.DropTable(
                name: "users");

            migrationBuilder.CreateTable(
                name: "users",
                columns: table => new
                {
                    user_id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    username = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    email = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    password = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false),
                    active = table.Column<bool>(type: "boolean", nullable: false),
                    created = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    role = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_users", x => x.user_id);
                });

            migrationBuilder.CreateTable(
                name: "card",
                columns: table => new
                {
                    card_id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    user_id = table.Column<int>(type: "integer", nullable: false),
                    value = table.Column<decimal>(type: "numeric(10,2)", precision: 10, scale: 2, nullable: false),
                    active = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_card", x => x.card_id);
                    table.ForeignKey(
                        name: "user_user_id_fk",
                        column: x => x.user_id,
                        principalTable: "users",
                        principalColumn: "user_id");
                });

            migrationBuilder.CreateTable(
                name: "charger",
                columns: table => new
                {
                    charger_id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    name = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    latitude = table.Column<decimal>(type: "numeric(9,6)", precision: 9, scale: 6, nullable: false),
                    longitude = table.Column<decimal>(type: "numeric(9,6)", precision: 9, scale: 6, nullable: false),
                    created = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    creator = table.Column<int>(type: "integer", nullable: false),
                    lastsync = table.Column<DateTime>(type: "timestamp without time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_charger", x => x.charger_id);
                    table.ForeignKey(
                        name: "user_user_id_fk",
                        column: x => x.creator,
                        principalTable: "users",
                        principalColumn: "user_id");
                });

            migrationBuilder.CreateTable(
                name: "event",
                columns: table => new
                {
                    event_id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    charger_id = table.Column<int>(type: "integer", nullable: false),
                    starttime = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    endtime = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    volume = table.Column<decimal>(type: "numeric(10,2)", precision: 10, scale: 2, nullable: false),
                    user_id = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_event", x => x.event_id);
                    table.ForeignKey(
                        name: "charger_charger_id_fk",
                        column: x => x.charger_id,
                        principalTable: "charger",
                        principalColumn: "charger_id");
                    table.ForeignKey(
                        name: "user_user_id_fk",
                        column: x => x.user_id,
                        principalTable: "users",
                        principalColumn: "user_id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_card_user_id",
                table: "card",
                column: "user_id");

            migrationBuilder.CreateIndex(
                name: "IX_charger_creator",
                table: "charger",
                column: "creator");

            migrationBuilder.CreateIndex(
                name: "IX_event_charger_id",
                table: "event",
                column: "charger_id");

            migrationBuilder.CreateIndex(
                name: "IX_event_user_id",
                table: "event",
                column: "user_id");

            migrationBuilder.CreateIndex(
                name: "unique_email",
                table: "users",
                column: "email",
                unique: true);

            //populate database
            migrationBuilder.InsertData(
                table: "users",
                columns: new[] { "username", "email", "password", "active", "created", "role" },
                values: new object[,]
                {
                    { "user1", "user1@example.com", "password1", true, DateTime.Now, "user" },
                    { "user2", "user2@example.com", "password2", true, DateTime.Now, "user" },
                });
            }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "card");

            migrationBuilder.DropTable(
                name: "event");

            migrationBuilder.DropTable(
                name: "charger");

            migrationBuilder.DropTable(
                name: "users");
        }
    }
}

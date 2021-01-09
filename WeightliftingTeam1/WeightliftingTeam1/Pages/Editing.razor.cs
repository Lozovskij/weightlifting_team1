using Microsoft.AspNetCore.Components;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Telerik.Blazor.Components;
using WeightliftingTeam1.Models;

namespace WeightliftingTeam1.Pages
{
    public partial class Editing
    {
        public Task<IEnumerable<Athletes>> AthletesTask { get; set; }
        public Task<IEnumerable<Attempts>> AttemptsTask { get; set; }
        public Task<IEnumerable<Competitions>> CompetitionsTask { get; set; }
        public Task<IEnumerable<Countries>> CountriesTask { get; set; }
        public Task<IEnumerable<Disqualifications>> DisqualificationsTask { get; set; }
        public Task<IEnumerable<Periods>> PeriodsTask { get; set; }
        public Task<IEnumerable<Places>> PlacesTask { get; set; }
        public Task<IEnumerable<Records>> RecordsTask { get; set; }
        public Task<IEnumerable<RecordTypes>> RecordTypesTask { get; set; }
        public Task<IEnumerable<WeightCategories>> WeightCategoriesTask { get; set; }

        protected override void OnInitialized()
        {
            AthletesTask = Task.Run(() => dataRetrievalService.GetData<Athletes>());
            AttemptsTask = Task.Run(() => dataRetrievalService.GetData<Attempts>());
            CompetitionsTask = Task.Run(() => dataRetrievalService.GetData<Competitions>());
            CountriesTask = Task.Run(() => dataRetrievalService.GetData<Countries>());
            DisqualificationsTask = Task.Run(() => dataRetrievalService.GetData<Disqualifications>());
            PeriodsTask = Task.Run(() => dataRetrievalService.GetData<Periods>());
            PlacesTask = Task.Run(() => dataRetrievalService.GetData<Places>());
            RecordsTask = Task.Run(() => dataRetrievalService.GetData<Records>());
            RecordTypesTask = Task.Run(() => dataRetrievalService.GetData<RecordTypes>());
            WeightCategoriesTask = Task.Run(() => dataRetrievalService.GetData<WeightCategories>());
        }
    }
}

using Microsoft.AspNetCore.Components;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Telerik.Blazor.Components;
using WeightliftingTeam1.Components;
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

        public bool AthletesShown { get; set; }
        public bool AttemptsShown { get; set; }
        public bool CompetitionsShown { get; set; }
        public bool CountriesShown { get; set; }
        public bool DisqualificationsShown { get; set; }
        public bool PeriodsShown { get; set; }
        public bool PlacesShown { get; set; }
        public bool RecordsShown { get; set; }
        public bool RecordTypesShown { get; set; }
        public bool WeightCategoriesShown { get; set; }

        public GridForEditing<Athletes> AthletesGridForEditing { get; set; }
        public GridForEditing<Attempts> AttemptsGridForEditing { get; set; }
        public GridForEditing<Competitions> CompetitionsGridForEditing { get; set; }
        public GridForEditing<Countries> CountriesGridForEditing { get; set; }
        public GridForEditing<Disqualifications> DisqualificationsGridForEditing { get; set; }
        public GridForEditing<Periods> PeriodsGridForEditing { get; set; }
        public GridForEditing<Places> PlacesGridForEditing { get; set; }
        public GridForEditing<Records> RecordsGridForEditing { get; set; }
        public GridForEditing<RecordTypes> RecordTypesGridForEditing { get; set; }
        public GridForEditing<WeightCategories> WeightCategoriesGridForEditing { get; set; }
        

        private void UpdataDataForViews()
        {
            AthletesGridForEditing.UpdateDataForView();
            AttemptsGridForEditing.UpdateDataForView();
            CompetitionsGridForEditing.UpdateDataForView();
            CountriesGridForEditing.UpdateDataForView();
            DisqualificationsGridForEditing.UpdateDataForView();
            PeriodsGridForEditing.UpdateDataForView();
            PlacesGridForEditing.UpdateDataForView();
            RecordsGridForEditing.UpdateDataForView();
            RecordTypesGridForEditing.UpdateDataForView();
            WeightCategoriesGridForEditing.UpdateDataForView();
        }

        protected override void OnInitialized()
        {
            AthletesTask = Task.Run(() => (IEnumerable<Athletes>)dataRetrievalService.GetData<Athletes>().OrderBy(item => item.Id));
            AttemptsTask = Task.Run(() => (IEnumerable<Attempts>)dataRetrievalService.GetData<Attempts>().OrderBy(item => item.Id));
            CompetitionsTask = Task.Run(() => (IEnumerable<Competitions>)dataRetrievalService.GetData<Competitions>().OrderBy(item => item.Id));
            CountriesTask = Task.Run(() => (IEnumerable<Countries>)dataRetrievalService.GetData<Countries>().OrderBy(item => item.Id));
            DisqualificationsTask = Task.Run(() => (IEnumerable<Disqualifications>)dataRetrievalService.GetData<Disqualifications>().OrderBy(item => item.Id));
            PeriodsTask = Task.Run(() => (IEnumerable<Periods>)dataRetrievalService.GetData<Periods>().OrderBy(item => item.Id));
            PlacesTask = Task.Run(() => (IEnumerable<Places>)dataRetrievalService.GetData<Places>().OrderBy(item => item.Id));
            RecordsTask = Task.Run(() => (IEnumerable<Records>)dataRetrievalService.GetData<Records>().OrderBy(item => item.Id));
            RecordTypesTask = Task.Run(() => (IEnumerable<RecordTypes>)dataRetrievalService.GetData<RecordTypes>().OrderBy(item => item.Id));
            WeightCategoriesTask = Task.Run(() => (IEnumerable<WeightCategories>)dataRetrievalService.GetData<WeightCategories>().OrderBy(item => item.Id));
        }
    }
}

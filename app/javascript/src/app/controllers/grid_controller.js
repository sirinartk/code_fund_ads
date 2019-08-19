import { Controller } from 'stimulus';

export default class extends Controller {
  connect() {
    if (this.element.dataset.gridInitialized) return;
    this.$grid = $(this.element).kendoGrid({
      sortable: true,
      filterable: true,
      groupable: true,
      pageable: true,
    });
    this.element.dataset.gridInitialized = true;
    this.grid = this.$grid.getKendoGrid();
    this.datasource = this.grid.dataSource;
    this.datasource.pageSize(this.pageSize);
    this.datasource.page(1);
    this.$grid.refresh();
  }

  get pageSize() {
    return Number(this.element.dataset.pageSize || 10);
  }
}

import { Controller } from 'stimulus';

export default class extends Controller {
  connect() {
    if (this.grid) return;
    const $grid = $(this.element).kendoGrid({
      sortable: true,
      filterable: true,
      groupable: true,
      pageable: true,
    });
    this.grid = $grid.getKendoGrid();
    this.grid.dataSource.pageSize(this.pageSize);
    this.grid.dataSource.page(1);
    if (this.grouping) this.grid.dataSource.group(this.grouping);
  }

  get pageSize() {
    return Number(this.element.dataset.pageSize || 10);
  }

  get grouping() {
    return this.element.dataset.grouping;
  }
}

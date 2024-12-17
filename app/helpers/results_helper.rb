module ResultsHelper
  def status_image(status)
    if status == 'SUCCESS'
      '<span class="badge bg-success"><i class="bi bi-check-circle me-1"></i>Pass</span>'
    elsif status == 'ERROR'
      '<span class="badge bg-danger"><i class="bi bi-x-circle me-1"></i>Fail</span>'
    elsif status == 'PENDING'
      '<span class="badge bg-secondary"><i class="bi bi-truck me-1"></i>Pending</span>'
    end
  end
end

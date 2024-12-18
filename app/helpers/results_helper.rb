module ResultsHelper
  def status_image(status)
    if status == 'SUCCESS'
      '<i class="bi bi-hand-thumbs-up-fill me-1 text-success" title="PASS" alt="PASS"></i>'
    elsif status == 'ERROR'
      '<i class="bi bi-hand-thumbs-down-fill me-1 text-danger" title="FAIL" alt="FAIL"></i>'
    elsif status == 'PENDING'
      '<i class="bi bi-truck me-1 text-secondary" title="PENDING" alt="PENDING"></i>'
    end
  end
end

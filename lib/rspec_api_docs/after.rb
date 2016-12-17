module RspecApiDocs
  After = -> (example) do
    metadata = example.metadata[METADATA_NAMESPACE]

    if metadata
      metadata[:requests] ||= []
      metadata[:requests] << [last_request, last_response]
    end
  end
end

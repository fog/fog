def volume_service
  Fog::Volume[:sakuracloud]
end

def compute_service
  Fog::Compute[:sakuracloud]
end

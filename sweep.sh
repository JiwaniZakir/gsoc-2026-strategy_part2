#!/bin/bash
# GSoC 2026 Competition Sweep - March 19, 2026
# Checks external PR volume and merge rate for 100+ repos

OUTPUT="/Users/zakirjiwani/projects/clones/gsoc-2026-strategy_part2/sweep_results.csv"
echo "repo,stars,ext_prs,ext_merges" > "$OUTPUT"

REPOS=(
  # Our current targets
  "aboutcode-org/vulnerablecode"
  "zulip/zulip"
  "accordproject/cicero"
  "accordproject/concerto"
  "honeynet/GreedyBear"
  "intelowlproject/IntelOwl"
  "dora-rs/dora"
  "wagtail/wagtail"
  # AI/ML orgs
  "deepchem/deepchem"
  "projectmesa/mesa"
  "kornia/kornia"
  "pyro-ppl/numpyro"
  "tardis-sn/tardis"
  "MDAnalysis/mdanalysis"
  "mandiant/capa"
  "mandiant/flare-floss"
  # Python orgs
  "sympy/sympy"
  "oppia/oppia"
  "learningequality/kolibri"
  "Submitty/Submitty"
  "sugarlabs/musicblocks"
  "sugarlabs/sugar"
  # Web/full-stack
  "laurent22/joplin"
  "RocketChat/Rocket.Chat"
  "CircuitVerse/CircuitVerse"
  "mozilla/pontoon"
  "processing/processing4"
  # Security
  "AFLplusplus/AFLplusplus"
  "rapid7/metasploit-framework"
  "prowler-cloud/prowler"
  # Systems/infra
  "checkpoint-restore/criu"
  "chapel-lang/chapel"
  "qemu/qemu"
  # Big orgs (for comparison)
  "django/django"
  "ffmpeg/FFmpeg"
  "git/git"
  "neovim/neovim"
  "Homebrew/brew"
  # Other GSoC orgs
  "keploy/keploy"
  "AOSSIE-Org/Agora"
  "AOSSIE-Org/PictoPy"
  "creativecommons/cccatalog-api"
  "dbpedia/extraction-framework"
  "BRL-CAD/brlcad"
  "ardupilot/ardupilot"
  "graphite-editor/Graphite"
  "apache/dolphinscheduler"
  "CamDavidsonPilon/lifelines"
  "apertium/apertium"
  "mixxx/mixxx"
  "metabrainz/listenbrainz-server"
  "catrobat/Catroid"
  "openclimatefix/pvnet"
  "openclimatefix/quartz-solar-forecast"
  "aboutcode-org/scancode-toolkit"
  "MariaDB/server"
  "matrix-org/synapse"
  "opensuse/open-build-service"
  "scummvm/scummvm"
  "videolan/vlc"
  "FluxML/Flux.jl"
  "foss42/apidash"
  "lcompilers/lpython"
)

for REPO in "${REPOS[@]}"; do
  STARS=$(gh api "repos/$REPO" --jq '.stargazers_count' 2>/dev/null || echo "ERR")
  if [ "$STARS" = "ERR" ]; then
    echo "$REPO,ERR,ERR,ERR" >> "$OUTPUT"
    sleep 0.2
    continue
  fi

  EXT_PRS=$(gh api "repos/$REPO/pulls?state=all&sort=created&direction=desc&per_page=50" \
    --jq '[.[] | select(.author_association == "NONE" or .author_association == "FIRST_TIMER" or .author_association == "FIRST_TIME_CONTRIBUTOR" or .author_association == "CONTRIBUTOR")] | length' 2>/dev/null || echo 0)

  EXT_MERGES=$(gh api "repos/$REPO/pulls?state=closed&sort=updated&direction=desc&per_page=50" \
    --jq '[.[] | select(.merged_at != null) | select(.author_association != "MEMBER" and .author_association != "OWNER" and .author_association != "COLLABORATOR")] | length' 2>/dev/null || echo 0)

  echo "$REPO,$STARS,$EXT_PRS,$EXT_MERGES" >> "$OUTPUT"
  echo "  ✓ $REPO: ⭐$STARS ext_prs=$EXT_PRS ext_merges=$EXT_MERGES"
  sleep 0.3
done

echo "Done! Results in $OUTPUT"

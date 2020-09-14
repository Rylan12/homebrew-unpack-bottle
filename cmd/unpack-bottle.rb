# frozen_string_literal: true

require "stringio"
require "formula"
require "cli/parser"
require "utils/tar"

module Homebrew
  module_function

  def unpack_bottle_args
    Homebrew::CLI::Parser.new do
      usage_banner <<~EOS
        `unpack-bottle` [<options>] <formula>

        Unpack the bottles for <formula> into subdirectories of the current
        working directory.
      EOS
      flag   "--destdir=",
             description: "Create subdirectories in the directory named by <path> instead."
      switch "--leave-nested",
             description: "Leave the unpacked bottle nested in subdirectories as it would be in the Cellar."
      switch "-f", "--force",
             description: "Overwrite the destination directory if it already exists."

      conflicts "--git", "--patch"
      min_named :formula
    end
  end

  def unpack_bottle
    args = unpack_bottle_args.parse

    formulae = args.named.to_formulae

    if (dir = args.destdir)
      unpack_dir = Pathname.new(dir).expand_path
      unpack_dir.mkpath
    else
      unpack_dir = Pathname.pwd
    end

    raise "Cannot write to #{unpack_dir}" unless unpack_dir.writable_real?

    formulae.each do |f|
      if f.bottle.nil?
        oh1 "No bottles found for #{f.name}-#{f.pkg_version}"
        next
      end

      final_dir = unpack_dir/"#{f.name}-#{f.pkg_version}"

      if final_dir.exist?
        raise "Destination #{f.name}-#{f.pkg_version} already exists!" unless args.force?

        rm_rf final_dir
      end

      oh1 "Unpacking #{Formatter.identifier(f.full_name)} to: #{final_dir}"

      bottle_archive = f.bottle.fetch

      Utils::Tar.validate_file bottle_archive

      Dir.mktmpdir do |tmp_unpack_dir|
        tmp_unpack_dir = Pathname.new(tmp_unpack_dir)

        UnpackStrategy.detect(bottle_archive, prioritise_extension: true)
                      .extract_nestedly(to: tmp_unpack_dir, prioritise_extension: true, verbose: args.verbose?)

        if args.leave_nested?
          cp_r tmp_unpack_dir, final_dir
        else
          cp_r tmp_unpack_dir/f.name/f.pkg_version, final_dir
        end
      end
    end
  end
end

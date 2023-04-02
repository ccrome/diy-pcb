import subprocess
import argparse
import os
import time

def get_args():
    parser = argparse.ArgumentParser(description='Convert gerber files to stl')
    parser.add_argument("input", help='gerber file to convert')
    parser.add_argument("output", help='stl file to create')
    return parser.parse_args()

def gerber2svg(input, output):
    # Create an svg file from the gerber file using flatcam
    # First, create a flatcam script:
    abs_input = os.path.abspath(input)
    abs_output = os.path.abspath(output)
    script = f"""
        open_gerber {abs_input} -outname input
        export_svg input {abs_output}
    """
    script_fn = f"{input}.fc"
    abs_script_fn = os.path.abspath(script_fn)
    with open(abs_script_fn, 'w') as f:
        f.write(script)
    r = subprocess.Popen(['flatcam', '--shellfile', abs_script_fn])
    time.sleep(3)
    r.kill()
    

#    fn = f"{input}.svg"
#    r = subprocess.run(['gerbv', '-x', 'svg', '-o', fn, input])
#    if r.returncode != 0:
#        raise Exception(f"gerbv failed to convert {input} to {fn}")
    return abs_output

def svg2stl(input, output):
    # Create an stl file from the svg file using openscad
    # First, create an openscad script:
    abs_input = os.path.abspath(input)
    fn = f"{input}.scad"
    abs_fn = os.path.abspath(fn)
    abs_output = os.path.abspath(output)
    script = f"""
        linear_extrude(height=0.05) import("{abs_input}");
        """
    with open(fn, 'w') as f:
        f.write(script)
    subprocess.run(['openscad', '-o', abs_output, abs_fn])
    return output

def main():
    args = get_args()
    print(args)
    print("starting gerber2svg")
    svg_fn = "/test.svg"
    gerber2svg(args.input, svg_fn)
    print("starting svg2stl")
    output_fn = svg2stl(svg_fn, args.output)
    print(f"Created {output_fn} from {args.input} and {svg_fn}.")

if __name__ == '__main__':
    main()
